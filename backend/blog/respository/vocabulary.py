from fastapi import Depends, status, HTTPException
from .. import schemas, models
from sqlalchemy import or_, and_
from typing import List

def add_vocabulary(request: schemas.Vocabulary, topic_id: int, db: Depends):
    new_vocabulary = models.Vocabulary(word= request.word, meaning= request.meaning, type= request.type, topic_id= topic_id)
    db.add(new_vocabulary)
    db.commit()
    db.refresh(new_vocabulary)
    return new_vocabulary

def get_vocabulary(topic_id: str, db: Depends, current_user: schemas.TokenData):
    topics =db.query(models.Topic).filter(or_( models.Topic.user_id == None, models.Topic.user_id == current_user.id)).all()
    for topic in topics:
        if topic.id == topic_id:
            return topic.vocabularys
    return 'not found'

def get_all_vocabulary(db: Depends, current_user: schemas.TokenData):
    topics =db.query(models.Topic).filter(or_( models.Topic.user_id == None, models.Topic.user_id == current_user.id)).all()
    vocabularys =[]
    for topic in topics:
        for vocabulary in topic.vocabularys:
            vocabularys.append(vocabulary)
    return vocabularys 


def delete_vocabulary(word: str,db: Depends, current_user: schemas.TokenData):
    topics =db.query(models.Topic).filter(models.Topic.user_id == current_user.id).all()
    for topic in topics:
        for vocabulary in topic.vocabularys:
            if(word == vocabulary.word):
                v =db.query(models.Vocabulary).filter(models.Vocabulary.id == vocabulary.id)
                if not v.all() :
                    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)
                v.delete()
                db.commit()
                return "deleted"
    return "not exsist"

    
