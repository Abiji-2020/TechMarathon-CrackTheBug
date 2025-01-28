const today = new Date();
let currentDate = new Date();

const year = currentDate.getFullYear();
const month = currentDate.getMonth();

const changeMonth = (direction) => {
  const newMonth = month + direction;
  currentDate = new Date(year, newMonth, 1);
  console.log(`Updated Date: ${currentDate}`);
};

console.log(`Current Date: ${currentDate}`);
changeMonth(1);
changeMonth(-2);
