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
exports.getUserById = void 0;
const user_1 = __importDefault(require("../models/user"));
const getUserById = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    try {
        const userId = (_a = req.user) === null || _a === void 0 ? void 0 : _a._id; // Extracting userId from req.user set by middleware
        if (!userId) {
            return res.status(400).json({ error: 'User ID not found in request' });
        }
        const user = yield user_1.default.findById(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }
        res.status(200).json({ user });
    }
    catch (err) {
        res.status(500).json({ error: 'Error getting user', details: err });
    }
});
exports.getUserById = getUserById;
