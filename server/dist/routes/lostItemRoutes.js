"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const lostItemController_1 = require("../controllers/lostItemController");
const claimController_1 = require("../controllers/claimController");
const lostItemRouter = (0, express_1.Router)();
lostItemRouter.post('/add', lostItemController_1.createLostItem);
lostItemRouter.get('/nearby', lostItemController_1.getNearbyLostItems); // Put this route before the ':id' route
lostItemRouter.get('/getAll', lostItemController_1.getAllLostItems);
lostItemRouter.get('/search', lostItemController_1.searchLostItem);
lostItemRouter.get('/:id', lostItemController_1.getLostItemById); // Place this after 'nearby'
lostItemRouter.put('/update/:id', lostItemController_1.updateLostItem);
lostItemRouter.delete('/delete/:id', lostItemController_1.deleteLostItem);
//claims routes
lostItemRouter.post('/claim/submit', claimController_1.submitClaim);
lostItemRouter.post('/claim/accept', claimController_1.acceptClaim);
lostItemRouter.post('/claim/reject', claimController_1.rejectClaim);
exports.default = lostItemRouter;
