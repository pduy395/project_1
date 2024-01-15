from fastapi import APIRouter, Depends, status
from .. import schemas, database, models
from sqlalchemy.orm import Session
from . import oauth2
from typing import List


from ..respository import test

router = APIRouter(
    prefix="/test",
    tags=['test'])

get_db = database.get_db

@router.post('/add_test_result/')
async def add_test_result(request: schemas.Test_result, db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return test.add_result(request,db,current_user)

@router.get('/get_result/', response_model=List[schemas.Test_result])
async def get_result(db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return test.get_result(db, current_user)

@router.get('/create_test/')
async def get_test( db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return test.get_test( db, current_user)


@router.get('/create_test_in_topic/')
async def get_test_in_topic(topic_id: int, db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return test.get_test_in_topic(topic_id, db, current_user)
