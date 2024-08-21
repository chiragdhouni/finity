

import { Request, Response } from 'express';
import Event from '../models/event';
import User from '../models/user'; // Import the User class from the appropriate module
import { ObjectId } from 'mongodb';


// Create a new event
export const createEvent = async (req: Request, res: Response) => {
    try {
        const {title,image, description, ownerId, date, address, location} = req.body;
        // const event = new Event(req.body);
        const owner = await User.findById(ownerId);

        if (!owner) {
            return res.status(404).send('Owner not found');
        }
        const event = new Event({
            title,
            image,
            description,
            owner: {
                id: owner._id,
                name: owner.name,
                email: owner.email,
                address: owner.address,
            },
            date,
            address,
            location,
        });
        
        await event.save();
        owner.events.push(event._id as ObjectId);
        owner.save();

        res.status(201).json(event);
    } catch (error) {
        console.error(`Error adding item: ${(error as Error).message}`);
    }
};

// Get all events
export const getEvents = async (req: Request, res: Response) => {
    try {
        const events = await Event.find();
        res.status(200).json(events);
    } catch (error) {
        console.error(`Error adding item: ${(error as Error).message}`);
    }
};

// // Get a single event by ID
// export const getEventById = async (req: Request, res: Response) => {
//     try {
//         const event = await Event.findById(req.params.id);
//         if (!event) return res.status(404).json({ message: 'Event not found' });
//         res.status(200).json(event);
//     } catch (error) {
//         console.error(`Error adding item: ${(error as Error).message}`);
//     }
// };

// Update an event
export const updateEvent = async (req: Request, res: Response) => {
    try {
        const event = await Event.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true,
        });
        if (!event) return res.status(404).json({ message: 'Event not found' });
        res.status(200).json(event);
    } catch (error) {
        console.error(`Error adding item: ${(error as Error).message}`);
    }
};

// Delete an event
export const deleteEvent = async (req: Request, res: Response) => {
    try {
        const event = await Event.findByIdAndDelete(req.params.id);
        if (!event) return res.status(404).json({ message: 'Event not found' });
        const owner = await User.findById(event.owner.id);
        if (!owner) {
            return res.status(404).send('Owner not found');
        }
        owner.events = owner.events.filter((eventId) => eventId.toString() !== (event._id as ObjectId).toString());
        res.status(200).json({ message: 'Event deleted successfully' });
    } catch (error) {
        console.error(`Error adding item: ${(error as Error).message}`);
    }
};

// Get events near a location, sorted by distance
export const getEventsNearLocation = async (req: Request, res: Response) => {
    try {
        const { latitude,longitude , maxDistance } = req.query;

        if (!longitude || !latitude) {
            return res.status(400).json({ message: 'Longitude and latitude are required' });
        }

        const events = await Event.aggregate([
            {
                $geoNear: {
                    near: {
                        type: 'Point',
                        coordinates: [parseFloat(longitude as string), parseFloat(latitude as string)],
                    },
                    distanceField: 'dist.calculated', // Field to add to the output documents containing the distance
                    maxDistance: parseFloat(maxDistance as string), // Max distance in meters
                    spherical: true,
                }
            },
            {
                $sort: { 'dist.calculated': 1 } // Sort by distance, ascending order
            }
        ]);

        res.status(200).json(events);
    } catch (error) {
        console.error(`Error fetching events near location: ${(error as Error).message}`);
        res.status(500).json({ message: 'Error fetching events near location' });
    }
};



