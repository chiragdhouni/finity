"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const eventController_1 = require("../controllers/eventController");
const auth_1 = require("../middlewares/auth");
const eventRouter = (0, express_1.Router)();
eventRouter.post('/addEvent', eventController_1.createEvent);
eventRouter.get('/', eventController_1.getEvents);
// eventRouter.get('/:id', getEventById); // Uncomment if you implement this function
eventRouter.put('/:id', eventController_1.updateEvent);
eventRouter.delete('/:id', auth_1.auth, eventController_1.deleteEvent);
eventRouter.get('/near', eventController_1.getEventsNearLocation);
exports.default = eventRouter;
