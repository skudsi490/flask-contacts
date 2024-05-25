from models import db, Contact
from faker import Faker
from app import app

fake = Faker()

# Push the application context
with app.app_context():
    # Reload tables
    db.drop_all()
    db.create_all()

    # Make 100 fake contacts
    for _ in range(100):
        fullname = fake.name().split()
        name = fullname[0]
        surname = ' '.join(fullname[1:])
        email = fake.email()
        phone = fake.phone_number()

        # Save in database
        contact = Contact(name=name, surname=surname, email=email, phone=phone)
        db.session.add(contact)

    db.session.commit()
