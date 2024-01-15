from fastapi import APIRouter, Depends, status, Response, HTTPException
from .. import schemas, database
from sqlalchemy.orm import Session
from ..respository import blog
from . import oauth2

router = APIRouter(
    prefix="/blog",
    tags=['blog'])

get_db = database.get_db

@router.post('/',status_code=status.HTTP_201_CREATED,)
def create(request: schemas.Blog,db: Session = Depends(get_db)):
    blog.create(request,db)

@router.get('/',status_code=200, )
def all(db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    
    return blog.show_all(db)

@router.get('/{id}',status_code=200, ) 
def show(id, response: Response, db: Session = Depends(get_db)):
    return blog.show_id(id,db)

@router.put('/{id}',status_code=status.HTTP_202_ACCEPTED,)
def update(id, request: schemas.Blog, db: Session = Depends(get_db)):
    return blog.update(id,request,db)

@router.delete('/{id}',status_code=status.HTTP_204_NO_CONTENT,)
def destroy(id, response: Response, db: Session = Depends(get_db)):
    return blog.destroy(id,db)
