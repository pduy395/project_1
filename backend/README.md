# Backend

This is the backend of the mobile application. It is built with FastAPI and Supabase.

## Getting Started

To get started with the backend, follow these steps:

1. Install the required Python packages:

```bash
$ cd backend/app
$ pip install -r requirements.txt
```

2. Set up your environment variables in the `.env` file. You will need to setup your database

3. Run the FastAPI application with host and port of your choice:, example:

```bash
$ uvicorn main:app --host 127.0.0.1 --port 5000 --reload
```

