from fastapi import Depends, status, HTTPException
from .. import schemas, models
from .. import hashing



def create(request:schemas.User, db:Depends):
    user = db.query(models.User).filter(models.User.email == request.email).first()
    if user:
        raise HTTPException(status_code=status.HTTP_406_NOT_ACCEPTABLE, detail="email is existed")

    new_user = models.User(user_name = request.user_name, email = request.email, password = hashing.Hash.bcrypt(request.password))
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

def show_me(db: Depends, current_user: schemas.TokenData):
    user = db.query(models.User).filter(models.User.id == current_user.id).first()
    return user

def show_user_by_email(email: str, db:Depends):
    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"User with email is {email} is not found")
    return user


def change_info(request:schemas.User, db:Depends, current_user: schemas.TokenData):
    user = db.query(models.User).filter(models.User.id == current_user.id)
    
    user.update({ "email" : request.email,"user_name" : request.user_name})
    db.commit()
    return user.first()

def change_pass(request:schemas.Change_pass, db:Depends, current_user: schemas.TokenData):
    user = db.query(models.User).filter(models.User.id == current_user.id)
    
    if not hashing.Hash.verify(user.first().password, request.old_pass):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='incorrect password')

    request.new_pass = hashing.Hash.bcrypt(request.new_pass)
    user.update({ "password" : request.new_pass })
    db.commit()
    return user.first()