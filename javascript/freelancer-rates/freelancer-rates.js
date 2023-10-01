// @ts-check

const BILLABLE_DAYS_PER_MONTH = 22;

/**
 * The day rate, given a rate per hour
 *
 * @param {number} ratePerHour
 * @returns {number} the rate per day
 */
export function dayRate(ratePerHour) {
  return ratePerHour * 8;
}

/**
 * Calculates the number of days in a budget, rounded down
 *
 * @param {number} budget: the total budget
 * @param {number} ratePerHour: the rate per hour
 * @returns {number} the number of days
 */
export function daysInBudget(budget, ratePerHour) {
  return Math.floor(budget / dayRate(ratePerHour));
}

/**
 * Calculates the discounted rate for large projects, rounded up
 *
 * @param {number} ratePerHour
 * @param {number} numDays: number of days the project spans
 * @param {number} discount: for example 20% written as 0.2
 * @returns {number} the rounded up discounted rate
 */
export function priceWithMonthlyDiscount(ratePerHour, numDays, discount) {
  let ratePerDay = dayRate(ratePerHour);
  let aboveDiscount = numDays % BILLABLE_DAYS_PER_MONTH;
  let aboveDiscountBill = aboveDiscount * ratePerDay;
  let beyondDiscountBill = (numDays - aboveDiscount) * ratePerDay * (1.0 - discount);

  return Math.ceil(aboveDiscountBill + beyondDiscountBill);
}
