from .. import schemas, models
from fastapi import Depends, HTTPException, status
from sqlalchemy import and_ , or_
from sqlalchemy.orm import joinedload, outerjoin
from typing import List

def user_create_topic(request: schemas.Topic, db: Depends, current_user: schemas.TokenData):
    new_topic = models.Topic(topic_name = request.topic_name, user_id = current_user.id)
    db.add(new_topic)
    db.commit()
    db.refresh(new_topic)
    return new_topic

def create_topic(request: schemas.Topic, db: Depends, ):
    new_topic = models.Topic(topic_name = request.topic_name, user_id = None)
    db.add(new_topic)
    db.commit()
    db.refresh(new_topic)
    return new_topic

def get_all_topic(db: Depends, current_user: schemas.TokenData):
    topics = (
        db.query(models.Topic)
        .outerjoin(models.Progress, and_(
            models.Progress.user_id == current_user.id,
            models.Progress.topic_id == models.Topic.id
        ))
        .filter(
            or_(models.Topic.user_id == None, models.Topic.user_id == current_user.id)
        )
        .options(joinedload(models.Topic.progresses))  # Đảm bảo load mối quan hệ
        .all()
    )
    list_tp =[]
    for tp in topics:
        if tp.progresses != []:
            list_tp.append(schemas.Topic(topic_name=tp.topic_name, id=tp.id, user_id= tp.user_id, progress= tp.progresses[0].progress))
        else:
            list_tp.append(schemas.Topic(topic_name=tp.topic_name, id=tp.id, user_id= tp.user_id, progress= 0))

    return list_tp



def destroy_topic(topic_id: int, db: Depends, current_user: schemas.TokenData):
    topics = db.query(models.Topic).filter(and_(models.Topic.user_id == current_user.id , models.Topic.id == topic_id))
    vocabularys = db.query(models.Vocabulary).filter(models.Vocabulary.topic_id == topic_id)
    progresses = db.query(models.Progress).filter(models.Progress.topic_id == topic_id)
    if not topics.all() :
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)
    vocabularys.delete()
    progresses.delete()
    topics.delete()
    db.commit()
    return  


def post_progress(request: schemas.Progress, db: Depends, current_user: schemas.TokenData):
    p = db.query(models.Progress).filter(and_( models.Progress.user_id == current_user.id, models.Progress.topic_id == request.topic_id))

    if p.first() == None :
        new_progress = models.Progress(progress = request.progress,user_id =current_user.id,topic_id = request.topic_id)
        db.add(new_progress)
        db.commit()
        db.refresh(new_progress)
        return new_progress
    
    if  p.first().progress < request.progress:
        p.update({"progress":request.progress})
        db.commit()