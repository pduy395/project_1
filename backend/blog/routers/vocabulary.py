from fastapi import APIRouter, Depends, status
from .. import schemas, database, models
from sqlalchemy.orm import Session
from . import oauth2
from sqlalchemy import and_, or_
from ..respository import vocabulary
from typing import List

router = APIRouter(
    prefix="/vocabulary",
    tags=['vocabulary'])

get_db = database.get_db

@router.post('/add/',status_code=status.HTTP_201_CREATED,)
async def add_vocabulary(request:schemas.Vocabulary, topic_id: int, db: Session = Depends(get_db)):
    return vocabulary.add_vocabulary(request,topic_id,db)


@router.get('/get_by_id/', response_model=List[schemas.Vocabulary])
async def get_vocabulary_in_topic(topic_id: int, db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return vocabulary.get_vocabulary(topic_id,db,current_user)
    

@router.get('/get_all/', response_model=List[schemas.Vocabulary])
async def get_vocabulary(db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return vocabulary.get_all_vocabulary(db,current_user)

@router.delete('/delete_vocabulary/')
async def get_vocabulary(word:str,db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return vocabulary.delete_vocabulary(word,db,current_user)

    
