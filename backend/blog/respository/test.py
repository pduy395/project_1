from .. import schemas, models
from fastapi import Depends, HTTPException, status
from . import vocabulary
import random

def add_result(request: schemas.Test_result, db: Depends, current_user: schemas.TokenData):
    new_test_result = models.Test_result(result = request.result, user_id = current_user.id)
    db.add(new_test_result)
    db.commit()
    db.refresh(new_test_result)
    return new_test_result

def get_result(db: Depends, current_user: schemas.TokenData):
    results = db.query(models.Test_result).filter(models.Test_result.user_id == current_user.id).order_by(models.Test_result.created_at.asc()).all()
    return results

def get_test( db: Depends, current_user: schemas.TokenData):
    vocabularys = vocabulary.get_all_vocabulary(db, current_user)
    
    vocabularys_list = list(vocabularys)
    random.shuffle(vocabularys_list)

    lq = []
    for v in vocabularys_list:
        crepe1 = vocabularys[random.randint(0,len(vocabularys)-1)].meaning
        crepe2 = vocabularys[random.randint(0,len(vocabularys)-1)].meaning
        crepe3 = vocabularys[random.randint(0,len(vocabularys)-1)].meaning

        while(crepe1 == v.meaning):
            crepe1 = vocabularys[random.randint(0,len(vocabularys)-1)].meaning
        while(crepe2 == v.meaning or crepe2 == crepe1):
            crepe2 = vocabularys[random.randint(0,len(vocabularys)-1)].meaning
        while(crepe3 == v.meaning or crepe3 == crepe1 or crepe2 == crepe3):
            crepe3 = vocabularys[random.randint(0,len(vocabularys)-1)].meaning

        q = schemas.Question(word= v.word, type= v.type, meaning= v.meaning, crepe1= crepe1, crepe2=crepe2, crepe3=crepe3)
        lq.append(q)
    return lq


def get_test_in_topic(topic_id:int, db: Depends, current_user: schemas.TokenData):
    all_vocabularys = vocabulary.get_all_vocabulary(db, current_user)
    vocabularys = vocabulary.get_vocabulary(topic_id, db, current_user)

    vocabularys_list = list(vocabularys)
    random.shuffle(vocabularys_list)
    lq = []
    for v in vocabularys_list:
        crepe1 = all_vocabularys[random.randint(0,len(all_vocabularys)-1)].meaning
        crepe2 = all_vocabularys[random.randint(0,len(all_vocabularys)-1)].meaning
        crepe3 = all_vocabularys[random.randint(0,len(all_vocabularys)-1)].meaning

        while(crepe1 == v.meaning):
            crepe1 = all_vocabularys[random.randint(0,len(all_vocabularys)-1)].meaning
        while(crepe2 == v.meaning or crepe2 == crepe1):
            crepe2 = all_vocabularys[random.randint(0,len(all_vocabularys)-1)].meaning
        while(crepe3 == v.meaning or crepe3 == crepe1 or crepe2 == crepe3):
            crepe3 = all_vocabularys[random.randint(0,len(all_vocabularys)-1)].meaning

        q = schemas.Question(word= v.word, type= v.type, meaning= v.meaning, crepe1= crepe1, crepe2=crepe2, crepe3=crepe3)
        lq.append(q)
    return lq