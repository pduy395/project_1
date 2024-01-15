from pydantic import BaseModel
from datetime import datetime

class User(BaseModel):
    user_name: str
    email: str
    password: str

class Topic(BaseModel):
    topic_name: str

class Vocabulary(BaseModel):
    word: str
    meaning: str
    type: str
    class Config():
        orm_mode = True

class Question(BaseModel):
    word: str
    meaning: str
    type: str
    crepe1: str
    crepe2: str
    crepe3: str
    class Config():
        orm_mode = True

class Test_result(BaseModel):
    result: int
    created_at: datetime
    class Config():
        orm_mode = True

class ShowUser(BaseModel):
    user_name: str
    email: str
    class Config():
        orm_mode = True

class Change_pass(BaseModel):
    new_pass:str
    old_pass:str

class Login(BaseModel):
    user_name: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    id: int| None = None

class Topic(BaseModel):
    id:int
    user_id:int | None
    progress:int 
    topic_name: str

class Progress(BaseModel):
    progress: int
    topic_id: int

