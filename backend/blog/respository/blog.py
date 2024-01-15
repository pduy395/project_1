from fastapi import Depends, status, HTTPException
from .. import models, schemas

def create(request:schemas.Blog, db: Depends):
    new_blog = models.Blog(title = request.title, body = request.body)
    db.add(new_blog)
    db.commit()
    db.refresh(new_blog)
    return new_blog

def show_all(db: Depends,):
    blogs = db.query(models.Blog).all()
    return blogs

def show_id(id:int, db:Depends):
    blog = db.query(models.Blog).filter(models.Blog.id == id).first()
    if not blog:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Blog with id is {id} is not found")
        
    return blog

def update(id:int, request:schemas.Blog, db: Depends):
    blog = db.query(models.Blog).filter(models.Blog.id == id)
    if not blog.all():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail=f"Blog with id is {id} is not found")

    blog.update(request.dict())
    db.commit()
    return 'update'

def destroy(id:int, db:Depends):
    blog = db.query(models.Blog).filter(models.Blog.id == id)
    if not blog.all():
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,detail=f"Blog with id is {id} is not found")
    blog.delete(synchronize_session=False)
    db.commit()
    return 'done'