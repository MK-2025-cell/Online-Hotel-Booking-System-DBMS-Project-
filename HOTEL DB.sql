DROP DATABASE HotelBookingDBFINAL;
CREATE DATABASE HotelBookingDBFINAL;
USE HotelBookingDBFINAL;

CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Address TEXT
);

CREATE TABLE Hotels (
    HotelID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL
);

CREATE TABLE Rooms (
    RoomID INT AUTO_INCREMENT,
    HotelID INT NOT NULL,
    RoomType ENUM('Single', 'Double', 'Suite') NOT NULL,
    PricePerNight DECIMAL(10,2) NOT NULL,
    Status ENUM('Available', 'Booked', 'Maintenance') DEFAULT 'Available',
    PRIMARY KEY (RoomID, HotelID),
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID) ON DELETE CASCADE
);

CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RoomID INT NOT NULL,
    HotelID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    Status ENUM('Confirmed', 'Cancelled', 'Completed') DEFAULT 'Confirmed',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID, HotelID) REFERENCES Rooms(RoomID, HotelID) ON DELETE CASCADE
);

CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL UNIQUE,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash') NOT NULL,
    Status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE
);

CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    HotelID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role ENUM('Manager', 'Receptionist', 'Housekeeping', 'Chef') NOT NULL,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID) ON DELETE CASCADE
);

CREATE TABLE Services (
    ServiceID INT AUTO_INCREMENT PRIMARY KEY,
    HotelID INT NOT NULL,
    EmployeeId INT NOT NULL,
    ServiceName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    RequiresRoom BOOLEAN DEFAULT FALSE,
    RoomID INT NULL,
    DurationMinutes INT,
    FOREIGN KEY (RoomID, HotelID) REFERENCES Rooms(RoomID, HotelID),
    CHECK (NOT RequiresRoom OR RoomID IS NOT NULL),
    FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID)
);


CREATE TABLE Booking_Services (
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (BookingID, ServiceID),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID) ON DELETE CASCADE
);

CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    HotelID INT NOT NULL,
    Rating DECIMAL(2,1) CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    ReviewDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (HotelID) REFERENCES Hotels(HotelID) ON DELETE CASCADE
);

INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('Arafat', 'Rahman', 'arafat.rahman@example.com', '+8801712345678', '12/A Dhanmondi, Dhaka'),
('Farhana', 'Akter', 'farhana.akter@example.com', '+8801812345678', '25 Mirpur Road, Dhaka'),
('Rahim', 'Khan', 'rahim.khan@example.com', '+8801912345678', '34 Gulshan Avenue, Dhaka'),
('Tasnim', 'Begum', 'tasnim.begum@example.com', '+8801512345678', '78 Uttara, Dhaka'),
('Imran', 'Hossain', 'imran.hossain@example.com', '+8801612345678', '45 Banani, Dhaka'),
('Sabrina', 'Islam', 'sabrina.islam@example.com', '+8801312345678', '67 Motijheel, Dhaka'),
('Kamal', 'Ahmed', 'kamal.ahmed@example.com', '+8801412345678', '89 Bashundhara, Dhaka'),
('Nusrat', 'Jahan', 'nusrat.jahan@example.com', '+8801712345679', '23 Khulna'),
('Shafiq', 'Uddin', 'shafiq.uddin@example.com', '+8801812345679', '56 Sylhet'),
('Laila', 'Chowdhury', 'laila.chowdhury@example.com', '+8801912345679', '78 Chittagong'),
('Arif', 'Mia', 'arif.mia@example.com', '+8801512345679', '34 Rajshahi'),
('Nazia', 'Sultana', 'nazia.sultana@example.com', '+8801612345679', '12 Barisal'),
('Jamil', 'Haque', 'jamil.haque@example.com', '+8801312345679', '45 Rangpur'),
('Fahmida', 'Khatun', 'fahmida.khatun@example.com', '+8801412345679', '67 Comilla'),
('Sohel', 'Rana', 'sohel.rana@example.com', '+8801712345680', '89 Cox''s Bazar');

INSERT INTO Hotels (Name, Location) VALUES
('Pan Pacific Sonargaon', '107 Kazi Nazrul Islam Ave, Dhaka'),
('Radisson Blu Dhaka', 'Airport Road, Dhaka'),
('Westin Dhaka', 'Gulshan Avenue, Dhaka'),
('Amari Dhaka', 'Gulshan-2, Dhaka'),
('Hotel InterContinental', '1 Minto Road, Dhaka'),
('The Peninsula Chittagong', '486/B O.R. Nizam Road, Chittagong'),
('Grand Sultan Tea Resort', 'Srimangal, Moulvibazar'),
('Royal Tulip Sea Pearl', 'Kolatoli Road, Cox''s Bazar'),
('Hotel Castle Salam', 'M.A. Gani Road, Sylhet'),
('Hotel Millennium', 'Tongi Diversion Road, Gazipur'),
('Hotel Sarina', 'Plot-27, Road-17, Banani, Dhaka'),
('The Palace Luxury Resort', 'Savar, Dhaka'),
('Seagull Hotel', 'Holiday Mor, Cox''s Bazar'),
('Grand Park Hotel', 'Shahid Tajuddin Ahmed Ave, Dhaka'),
('Hotel Agrabad', 'Sabder Ali Road, Chittagong');

INSERT INTO Rooms (HotelID, RoomType, PricePerNight, Status) VALUES
(1, 'Single', 8500.00, 'Available'),
(1, 'Double', 12000.00, 'Available'),
(1, 'Suite', 25000.00, 'Available'),
(2, 'Single', 9000.00, 'Available'),
(2, 'Double', 13000.00, 'Booked'),
(2, 'Suite', 28000.00, 'Available'),
(3, 'Single', 9500.00, 'Booked'),
(3, 'Double', 14000.00, 'Available'),
(3, 'Suite', 30000.00, 'Maintenance'),
(4, 'Single', 8000.00, 'Available'),
(4, 'Double', 11500.00, 'Available'),
(4, 'Suite', 22000.00, 'Booked'),
(8, 'Single', 7500.00, 'Available'),
(8, 'Double', 11000.00, 'Available'),
(8, 'Suite', 20000.00, 'Available');

INSERT INTO Bookings (CustomerID, RoomID, HotelID, CheckInDate, CheckOutDate, Status) VALUES
(1, 2, 1, '2023-12-15', '2023-12-18', 'Confirmed'),
(2, 5, 2, '2023-12-20', '2023-12-25', 'Confirmed'),
(3, 7, 3, '2023-12-10', '2023-12-12', 'Completed'),
(4, 12, 4, '2024-01-05', '2024-01-10', 'Confirmed'),  
(5, 1, 1, '2023-12-22', '2023-12-24', 'Confirmed'),
(6, 9, 3, '2024-01-15', '2024-01-20', 'Confirmed'),
(7, 14, 8, '2023-12-28', '2024-01-02', 'Confirmed'),
(8, 3, 1, '2024-02-10', '2024-02-15', 'Confirmed'),
(9, 6, 2, '2023-12-05', '2023-12-08', 'Completed'),
(10, 11, 4, '2024-01-20', '2024-01-25', 'Confirmed'),
(11, 15, 8, '2024-02-15', '2024-02-20', 'Confirmed'),
(12, 4, 2, '2023-12-18', '2023-12-20', 'Cancelled'),
(13, 8, 3, '2024-01-08', '2024-01-12', 'Confirmed'),
(14, 10, 4, '2024-02-05', '2024-02-10', 'Confirmed'),
(15, 13, 8, '2023-12-30', '2024-01-05', 'Confirmed');

INSERT INTO Employees (HotelID, FirstName, LastName, Role) VALUES
(1, 'Abdul', 'Mannan', 'Manager'),
(1, 'Shirin', 'Akter', 'Receptionist'),
(1, 'Raju', 'Ahmed', 'Housekeeping'),
(2, 'Farid', 'Uddin', 'Manager'),
(2, 'Tania', 'Islam', 'Receptionist'),
(2, 'Mizan', 'Rahman', 'Chef'),
(3, 'Nasrin', 'Sultana', 'Manager'),
(3, 'Arif', 'Khan', 'Receptionist'),
(3, 'Liton', 'Das', 'Housekeeping'),
(4, 'Bilkis', 'Begum', 'Manager'),
(4, 'Shahid', 'Mia', 'Chef'),
(4, 'Runa', 'Laila', 'Receptionist'),
(8, 'Jamal', 'Hossain', 'Manager'),
(8, 'Nadia', 'Chowdhury', 'Receptionist'),
(8, 'Ratan', 'Chakma', 'Housekeeping');

INSERT INTO Services (HotelID, EmployeeID, ServiceName, Price, RequiresRoom, RoomID, DurationMinutes) VALUES
(1,1,'Breakfast Buffet', 800.00, FALSE, NULL, NULL),
(1, 1,'Spa Treatment',  2500.00, FALSE, NULL, 60),
(1, 1,'Room Service (24/7)',  500.00, TRUE, 1, NULL),
(2, 1,'Airport Transfer',  1200.00, FALSE, NULL, NULL),
(2, 2,'Swimming Pool Access',   600.00, FALSE, NULL, 120),
(2, 2,'Laundry Service',  300.00, TRUE, 5, NULL),
(3, 2,'Business Center',  400.00, FALSE, NULL, NULL),
(3, 2,'Gym Access', 500.00,  FALSE, NULL, NULL),
(3,  2,'Minibar Restock', 1000.00, TRUE, 7, NULL),
(8, 3,'Beachside Dinner',  1500.00, FALSE, NULL, NULL),
(8, 4, 'Sea Pearl Spa', 3000.00, FALSE, NULL, 90),
(8, 5,'Boat Tour',  2000.00, FALSE, NULL, 180),
(4, 6,'Conference Room',  5000.00, FALSE, NULL, NULL),
(4, 7,'Car Rental',  2500.00, FALSE, NULL, NULL),
(4,  8, 'Evening Tea',300.00, TRUE, 12, NULL);


INSERT INTO Booking_Services (BookingID, ServiceID, Quantity) VALUES
(1, 1, 3),
(1, 3, 2),
(2, 4, 1),
(3, 7, 1),
(3, 8, 3),
(4, 14, 1),
(5, 1, 2),
(6, 9, 1),
(7, 10, 2),
(7, 11, 1),
(8, 2, 1),
(9, 5, 2),
(10, 15, 3),
(11, 12, 1),
(13, 6, 1);

INSERT INTO Payments (BookingID, PaymentDate, Amount, PaymentMethod, Status) VALUES
(1, '2023-12-14', 43200.00, 'Credit Card', 'Completed'),
(2, '2023-12-19', 78000.00, 'Debit Card', 'Completed'),
(3, '2023-12-09', 28500.00, 'Cash', 'Completed'),
(4, '2024-01-04', 67500.00, 'Credit Card', 'Pending'),
(5, '2023-12-21', 19600.00, 'PayPal', 'Completed'),
(6, '2024-01-14', 84000.00, 'Credit Card', 'Pending'),
(7, '2023-12-27', 66000.00, 'Debit Card', 'Completed'),
(8, '2024-02-09', 125000.00, 'Credit Card', 'Pending'),
(9, '2023-12-04', 39000.00, 'Cash', 'Completed'),
(10, '2024-01-19', 69000.00, 'PayPal', 'Pending'),
(11, '2024-02-14', 80000.00, 'Credit Card', 'Pending'),
(12, '2023-12-17', 18000.00, 'Debit Card', 'Failed'),
(13, '2024-01-07', 56000.00, 'Credit Card', 'Completed'),
(14, '2024-02-04', 57500.00, 'PayPal', 'Pending'),
(15, '2023-12-29', 105000.00, 'Credit Card', 'Completed');

INSERT INTO Reviews (CustomerID, HotelID, Rating, Comments, ReviewDate) VALUES
(1, 1, 4.5, 'Excellent service and comfortable stay', '2023-12-19'),
(2, 2, 4.0, 'Good but breakfast could be better', '2023-12-26'),
(3, 3, 4.8, 'Luxurious experience, highly recommended', '2023-12-13'),
(4, 4, 3.5, 'Average experience for the price', '2024-01-11'),
(5, 1, 4.2, 'Great location and friendly staff', '2023-12-25'),
(6, 3, 4.7, 'Perfect for business trips', '2024-01-21'),
(7, 8, 4.9, 'Best beachfront hotel in Cox''s Bazar!', '2024-01-03'),
(8, 1, 4.3, 'Good but overpriced', '2024-02-16'),
(9, 2, 3.8, 'Clean rooms but slow service', '2023-12-09'),
(10, 4, 4.1, 'Comfortable beds and good amenities', '2024-01-26'),
(11, 8, 4.6, 'Amazing sea view from the room', '2024-02-21'),
(12, 2, 2.5, 'Disappointing experience', '2023-12-19'),
(13, 3, 4.4, 'Would stay here again', '2024-01-13'),
(14, 4, 3.9, 'Decent but needs renovation', '2024-02-11'),
(15, 8, 5.0, 'Perfect vacation spot!', '2024-01-06');

