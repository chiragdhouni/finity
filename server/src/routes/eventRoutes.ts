import { Router } from 'express';
import {
    createEvent,
    getEvents,
    // getEventById, // Uncomment if you implement this function
    updateEvent,
    deleteEvent,
    getEventsNearLocation,
} from '../controllers/eventController';
import { auth } from '../middlewares/auth';


const eventRouter = Router();

eventRouter.post('/addEvent', createEvent);
eventRouter.get('/', getEvents);
// eventRouter.get('/:id', getEventById); // Uncomment if you implement this function
eventRouter.put('/:id',auth, updateEvent);
eventRouter.delete('/:id',auth, deleteEvent);
eventRouter.get('/near', getEventsNearLocation);


export default eventRouter;

