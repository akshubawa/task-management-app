import { prisma } from "../utils/prisma";
import { Request, Response } from "express";

export const createTask = async (req: any, res: Response) => {
  try {
    const { title } = req.body;

    if (!title) {
      return res.status(400).json({
        status: false,
        message: "Title is required",
        data: null,
      });
    }

    const task = await prisma.task.create({
      data: {
        title,
        userId: req.userId,
      },
    });

    return res.status(201).json({
      status: true,
      message: "Task created successfully",
      data: task,
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      data: null,
    });
  }
};

export const getTasks = async (req: any, res: Response) => {
  try {
    const { page = 1, limit = 5, status, search } = req.query;

    const currentPage = Number(page);
    const pageLimit = Number(limit);

    const whereCondition: any = {
      userId: req.userId,
      ...(status !== undefined && { status: status === "true" }),
      ...(search && {
        title: { contains: search as string, mode: "insensitive" },
      }),
    };

    const totalRecords = await prisma.task.count({
      where: whereCondition,
    });

    const tasks = await prisma.task.findMany({
      where: whereCondition,
      skip: (currentPage - 1) * pageLimit,
      take: pageLimit,
      orderBy: { createdAt: "desc" },
    });

    const totalPages = Math.ceil(totalRecords / pageLimit);

    return res.status(200).json({
      status: true,
      message: "Tasks fetched successfully",
      data: {
        tasks,
        pagination: {
          totalRecords,
          totalPages,
          currentPage,
          limit: pageLimit,
          hasNextPage: currentPage < totalPages,
          hasPreviousPage: currentPage > 1,
        },
      },
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      data: null,
    });
  }
};


export const updateTask = async (req: any, res: Response) => {
  try {
    const { id } = req.params;
    const { title } = req.body;

    const task = await prisma.task.findFirst({
      where: { id, userId: req.userId },
    });

    if (!task) {
      return res.status(404).json({
        status: false,
        message: "Task not found",
        data: null,
      });
    }

    const updatedTask = await prisma.task.update({
      where: { id },
      data: { title },
    });

    return res.status(200).json({
      status: true,
      message: "Task updated successfully",
      data: updatedTask,
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      data: null,
    });
  }
};

export const deleteTask = async (req: any, res: Response) => {
  try {
    const { id } = req.params;

    const task = await prisma.task.findFirst({
      where: { id, userId: req.userId },
    });

    if (!task) {
      return res.status(404).json({
        status: false,
        message: "Task not found",
        data: null,
      });
    }

    await prisma.task.delete({
      where: { id },
    });

    return res.status(200).json({
      status: true,
      message: "Task deleted successfully",
      data: null,
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      data: null,
    });
  }
};

export const toggleTask = async (req: any, res: Response) => {
  try {
    const { id } = req.params;

    const task = await prisma.task.findFirst({
      where: { id, userId: req.userId },
    });

    if (!task) {
      return res.status(404).json({
        status: false,
        message: "Task not found",
        data: null,
      });
    }

    const updatedTask = await prisma.task.update({
      where: { id },
      data: { status: !task.status },
    });

    return res.status(200).json({
      status: true,
      message: "Task status updated successfully",
      data: updatedTask,
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      data: null,
    });
  }
};
