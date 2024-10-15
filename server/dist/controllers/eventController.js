"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getEventsNearLocation = exports.deleteEvent = exports.updateEvent = exports.getEvents = exports.createEvent = void 0;
const event_1 = __importDefault(require("../models/event"));
const user_1 = __importDefault(require("../models/user")); // Import the User class from the appropriate module
// Create a new event
const createEvent = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { title, image, description, ownerId, date, address, location } = req.body;
        // const event = new Event(req.body);
        const owner = yield user_1.default.findById(ownerId);
        if (!owner) {
            return res.status(404).send('Owner not found');
        }
        const event = new event_1.default({
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
        yield event.save();
        owner.events.push(event._id);
        owner.save();
        res.status(201).json(event);
    }
    catch (error) {
        console.error(`Error adding item: ${error.message}`);
    }
});
exports.createEvent = createEvent;
// Get all events
const getEvents = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const events = yield event_1.default.find();
        res.status(200).json(events);
    }
    catch (error) {
        console.error(`Error adding item: ${error.message}`);
    }
});
exports.getEvents = getEvents;
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
const updateEvent = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const event = yield event_1.default.findByIdAndUpdate(req.params.id, req.body, {
            new: true,
            runValidators: true,
        });
        if (!event)
            return res.status(404).json({ message: 'Event not found' });
        res.status(200).json(event);
    }
    catch (error) {
        console.error(`Error adding item: ${error.message}`);
    }
});
exports.updateEvent = updateEvent;
// Delete an event
const deleteEvent = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const event = yield event_1.default.findById(req.params.id);
        // Check if the event exists
        if (!event) {
            return res.status(404).json({ message: 'Event not found' });
        }
        // Ensure the user is authorized to delete the event
        if (event.owner.id.toString() !== ((_a = req.user) === null || _a === void 0 ? void 0 : _a._id).toString()) {
            return res.status(403).json({ message: 'You are not authorized to delete this event' });
        }
        // Find the owner of the event
        const owner = yield user_1.default.findById(event.owner.id);
        if (!owner) {
            return res.status(404).json({ message: 'Owner not found' });
        }
        // Remove the event from the owner's list
        owner.events = owner.events.filter((eventId) => eventId.toString() !== event._id.toString());
        // Save the updated owner
        yield owner.save();
        // Delete the event
        yield event_1.default.findByIdAndDelete(req.params.id);
        // Send success response
        res.status(200).json({ message: 'Event deleted successfully' });
    }
    catch (error) {
        console.error(`Error deleting event: ${error.message}`);
        res.status(500).json({ message: 'Internal server error' });
    }
});
exports.deleteEvent = deleteEvent;
// Get events near a location, sorted by distance
const getEventsNearLocation = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const { latitude, longitude, maxDistance } = req.query;
        if (!longitude || !latitude) {
            return res.status(400).json({ message: 'Longitude and latitude are required' });
        }
        const events = yield event_1.default.aggregate([
            {
                $geoNear: {
                    near: {
                        type: 'Point',
                        coordinates: [parseFloat(longitude), parseFloat(latitude)],
                    },
                    distanceField: 'dist.calculated', // Field to add to the output documents containing the distance
                    maxDistance: parseFloat(maxDistance), // Max distance in meters
                    spherical: true,
                }
            },
            {
                $sort: { 'dist.calculated': 1 } // Sort by distance, ascending order
            }
        ]);
        res.status(200).json(events);
    }
    catch (error) {
        console.error(`Error fetching events near location: ${error.message}`);
        res.status(500).json({ message: 'Error fetching events near location' });
    }
});
exports.getEventsNearLocation = getEventsNearLocation;
