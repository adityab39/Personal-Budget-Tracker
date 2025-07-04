import React from "react";
import CustomPieChart from "../Charts/CustomPieChart";

const COLORS = ["#f97316", "#EF4444", "#22C55E"];

const FinanceOverview = ({ totalBalance, totalIncome, totalExpense }) => {
  const balanceData = [
    { name: "Total Balance", amount: parseFloat(totalBalance) },
    { name: "Total Expenses", amount: parseFloat(totalExpense) },
    { name: "Total Income", amount: parseFloat(totalIncome) },
  ];

  return (
    <div className="card">
      <div className="flex items-center justify-between">
        <h5 className="text-lg">Financial Overview</h5>
      </div>

      <CustomPieChart
        data={balanceData}
        label="Total Balance"
        totalAmount={`$${parseFloat(totalBalance)}`}
        colors={COLORS}
        showTextAnchor
      />
    </div>
  );
};

export default FinanceOverview;