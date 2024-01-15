
from fastapi import FastAPI, File, UploadFile
from . import models
from .database import engine
from .routers import topic, user, authentication, vocabulary, test
from typing import Annotated
from fastapi.middleware.cors import CORSMiddleware
import uvicorn


app = FastAPI()

if __name__ == '__main__':
    uvicorn.run(app, port=8080, host='0.0.0.0')


models.Base.metadata.create_all(engine)


app.include_router(authentication.router)
app.include_router(user.router)
app.include_router(topic.router)
app.include_router(vocabulary.router)
app.include_router(test.router)


@app.post("/uploadfile/")
async def create_upload_file(
    file: Annotated[UploadFile, File(description="A file read as UploadFile")],
):
    return {"filename": file}

origins = ['http://localhost:8000','http://192.168.178.23:8080']
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)




