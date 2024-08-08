import { Router } from 'express';
import {
    createEvent,
    getEvents,
    // getEventById, // Uncomment if you implement this function
    updateEvent,
    deleteEvent,
    getEventsNearLocation,
} from '../controllers/eventController';


const eventRouter = Router();

eventRouter.post('/addEvent', createEvent);
eventRouter.get('/', getEvents);
// eventRouter.get('/:id', getEventById); // Uncomment if you implement this function
eventRouter.put('/:id', updateEvent);
eventRouter.delete('/:id', deleteEvent);
eventRouter.get('/near', getEventsNearLocation);

export default eventRouter;

