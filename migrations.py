from models import db, Contact
from faker import Faker
from app import app

fake = Faker()


with app.app_context():
    # Reload tables
    db.drop_all()
    db.create_all()

    
    for _ in range(100):
        fullname = fake.name().split()
        name = fullname[0]
        surname = ' '.join(fullname[1:])
        email = fake.email()
        phone = fake.phone_number()

        
        contact = Contact(name=name, surname=surname, email=email, phone=phone)
        db.session.add(contact)

    db.session.commit()
