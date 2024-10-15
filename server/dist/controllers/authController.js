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
exports.updateUserLocation = exports.tokenIsValid = exports.loginUser = exports.registerUser = void 0;
const user_1 = __importDefault(require("../models/user"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const registerUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { name, email, password, address, profilePicture } = req.body;
    try {
        const existingUser = yield user_1.default.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: "User with the same email already exists!" });
        }
        const hashedPassword = yield bcryptjs_1.default.hash(password, 10);
        const user = new user_1.default({
            name,
            email,
            password: hashedPassword,
            address: address,
            profilePicture: "",
            location: { type: "Point", coordinates: [0.0, 0.0] }, // Initialize with default coordinates
            itemsListed: [],
            itemsLended: [],
            itemsBorrowed: [],
            itemsRequested: [],
            notifications: [],
        });
        yield user.save();
        res.status(201).json({ user });
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
});
exports.registerUser = registerUser;
const loginUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email, password } = req.body;
    try {
        const user = yield user_1.default.findOne({ email }).lean(); // Use lean() to get a plain object
        if (!user) {
            return res.status(400).json({ msg: "User with this email does not exist!" });
        }
        const isMatch = yield bcryptjs_1.default.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect password." });
        }
        const token = jsonwebtoken_1.default.sign({ id: user._id }, "passwordKey");
        res.status(201).json({ token, user });
    }
    catch (error) {
        res.status(400).send({ error: error.message });
    }
});
exports.loginUser = loginUser;
const tokenIsValid = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = req.header("x-auth-token");
        if (!token)
            return res.json(false);
        // Verify the token and ensure it's of the expected type
        const verified = jsonwebtoken_1.default.verify(token, "passwordKey");
        // Check if the verified object has the id property
        if (!verified || !verified.id)
            return res.json(false);
        const user = yield user_1.default.findById(verified.id);
        if (!user)
            return res.json(false);
        res.json(true);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});
exports.tokenIsValid = tokenIsValid;
// Update user location
const updateUserLocation = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { userId } = req.params;
    const { latitude, longitude } = req.body;
    if (!latitude || !longitude) {
        return res.status(400).json({ error: 'Latitude and longitude are required.' });
    }
    try {
        const user = yield user_1.default.findById(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found.' });
        }
        user.location = {
            type: 'Point',
            coordinates: [longitude, latitude],
        };
        yield user.save();
        res.status(200).json({ message: 'Location updated successfully.', user });
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
});
exports.updateUserLocation = updateUserLocation;
