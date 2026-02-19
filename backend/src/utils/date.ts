export function parseDateOnly(dateStr: string): Date {
  const [month, day, year] = dateStr.split("-").map(Number);

  if (!month || !day || !year) {
    throw new Error("Invalid date format. Expected MM-DD-YYYY");
  }

  return new Date(Date.UTC(year, month - 1, day));
}
