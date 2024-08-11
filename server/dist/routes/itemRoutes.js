"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const itemController_1 = require("../controllers/itemController");
const itemRouter = (0, express_1.Router)();
itemRouter.post('/add', itemController_1.addItem);
itemRouter.post('/request', itemController_1.requestToBorrowItem);
itemRouter.put('/lend', itemController_1.lendItem);
itemRouter.put('/return', itemController_1.returnItem);
itemRouter.get('/nearby', itemController_1.getNearbyItems);
itemRouter.get('/search', itemController_1.searchItems);
exports.default = itemRouter;
