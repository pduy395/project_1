from fastapi import APIRouter, Depends
from .. import schemas, models, database
from sqlalchemy.orm import Session
from ..respository import user
from fastapi.security import OAuth2PasswordBearer
from . import oauth2

router = APIRouter(
    prefix="/user",
    tags=['user'])

get_db = database.get_db
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

@router.post('/create_user',response_model=schemas.ShowUser,)
def create_user(request: schemas.User, db: Session = Depends(get_db)):
    return user.create(request,db)
    
@router.get('/get_by_email',response_model=schemas.ShowUser,)
def show_user_by_email(email: str, db: Session = Depends(get_db)):
    return user.show_user_by_email(email,db)



@router.get("/show_me",response_model=schemas.ShowUser)
async def show_me(db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return user.show_me(db,current_user)


@router.put("/change_info",response_model=schemas.ShowUser)
async def change_info(request: schemas.User,db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return user.change_info(request,db,current_user)


@router.put("/change_pass",response_model=schemas.ShowUser)
async def change_info(request: schemas.Change_pass,db: Session = Depends(get_db), current_user: schemas.TokenData = Depends(oauth2.get_current_user)):
    return user.change_pass(request,db,current_user)
