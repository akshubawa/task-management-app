import { z } from "zod";

export const registerSchema = z.object({
  fullName: z
    .string()
    .min(3, "Full name must be at least 3 characters")
    .max(50, "Full name too long"),

  email: z
    .string()
    .email("Invalid email format"),

  mobileNumber: z
    .string()
    .regex(/^[6-9]\d{9}$/, "Invalid mobile number"),

  password: z
    .string()
    .min(6, "Password must be at least 6 characters")
    .max(50, "Password too long"),
});

export const loginSchema = z.object({
  email: z
    .string()
    .email("Invalid email format"),

  password: z
    .string()
    .min(6, "Password must be at least 6 characters"),
});
