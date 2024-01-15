from fastapi import APIRouter, Depends, HTTPException, status
from .. import schemas, database, models, hashing
from sqlalchemy.orm import Session
from . import JWTtoken
from datetime import datetime, timedelta
from fastapi.security import OAuth2PasswordRequestForm
from typing import Annotated

router = APIRouter(
    tags=['Authenrication'])

@router.post('/login')
def login(request: Annotated[OAuth2PasswordRequestForm, Depends()] , db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == request.username).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail='not exist account')
    
    if not hashing.Hash.verify(user.password, request.password):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='incorrect password')


    access_token_expires = timedelta(minutes= JWTtoken.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = JWTtoken.create_access_token(
        data={"sub": str(user.id)}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}