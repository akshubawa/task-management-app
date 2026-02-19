import { z } from "zod";
import { Priority } from "@prisma/client";

export const createTaskSchema = z.object({
  title: z
    .string()
    .min(1, "Title is required")
    .max(100, "Title too long"),

  priority: z.nativeEnum(Priority).optional(),

  dueDate: z
    .string()
    .optional()
    .refine(
      (date) => !date || !isNaN(Date.parse(date)),
      "Invalid due date format"
    ),
});

export const updateTaskSchema = z.object({
  title: z
    .string()
    .min(1, "Title cannot be empty")
    .max(100)
    .optional(),

  priority: z.nativeEnum(Priority).optional(),

  dueDate: z
    .string()
    .optional()
    .refine(
      (date) => !date || !isNaN(Date.parse(date)),
      "Invalid due date format"
    ),
});
