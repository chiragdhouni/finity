import { Router } from "express";
import { getNotificationsForIds } from "../controllers/notification_controller";
import { auth } from "../middlewares/auth";




const notificationRoutes = Router();

notificationRoutes.post('/getNotifications',auth, getNotificationsForIds); 

export default notificationRoutes;
