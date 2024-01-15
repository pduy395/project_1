from fastapi import APIRouter, Depends, status, HTTPException, Response
from .. import schemas, database, models
from sqlalchemy.orm import Session 
from . import oauth2
from ..respository import topic

router = APIRouter(
    prefix="/topic",
    tags=['topic'])

get_db = database.get_db

@router.post('/create_topic/',status_code=status.HTTP_201_CREATED,)
def create(request: schemas.Topic,db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return topic.user_create_topic(request, db, current_user)

@router.post('/',status_code=status.HTTP_201_CREATED,)
def create(request: schemas.Topic,db: Session = Depends(get_db)):
    return topic.create_topic(request, db)
    

@router.get('/get_all_topic/',status_code=200)
def get_all_topic(db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return topic.get_all_topic(db, current_user)
    
@router.delete('/delete_topic/{topic_id}/')
def delete_topic(topic_id: int, db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return topic.destroy_topic(topic_id, db, current_user)   


@router.post('/post_progress/',status_code=200)
def post_progress(request: schemas.Progress,db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return topic.post_progress(request,db, current_user)


