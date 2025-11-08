abstract class BankAccount {
  // Private Fields
  int _accountNumber;
  String _accountHolderName;
  double _bankBalance;

  // Methods
  void withdraw(double amount);
  void deposit(double amount);
  void displayAccountInfo() {
    print("Account Number: $_accountNumber");
    print("Account Holder Name: $_accountHolderName");
    print("Bank Balance: \$$_bankBalance");
  }

  // Constructor
  BankAccount(this._accountNumber, this._accountHolderName, this._bankBalance);

  // Setter and Getter
  int get getAccountNumber {
    return _accountNumber;
  }

  set setAccountNumber(int accountNumber) {
    _accountNumber = accountNumber;
  }

  String get getAccountHolderName {
    return _accountHolderName;
  }

  set setAccountHolderName(String accountHolderName) {
    _accountHolderName = accountHolderName;
  }

  double get getbankBalance {
    return _bankBalance;
  }

  set setbankBalance(double bankBalance) {
    _bankBalance = bankBalance;
  }
}

class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawalsThisMonth = 0;
  static const _minimumBalance = 500;

  // Constructor
  SavingsAccount(
    int accountNumber,
    String accountHolderName,
    double bankBalance,
  ) : super(accountNumber, accountHolderName, bankBalance);

  @override
  void withdraw(double amount) {
    if (_withdrawalsThisMonth >= 3) {
      print("You’ve reached your withdrawal limit for this month.");
      return;
    }

    if (getbankBalance - amount < _minimumBalance) {
      print(
        "Withdrawal denied. A minimum balance of \$$_minimumBalance must be maintained.",
      );
      return;
    }

    setbankBalance = getbankBalance - amount;
    _withdrawalsThisMonth++;
    print(
      "Withdrawal completed successfully. Your new balance is: \$$getbankBalance",
    );
  }

  @override
  void deposit(double amount) {
    setbankBalance = getbankBalance + amount;
    print(
      "Amount Deposited Successfully. Your new balance is: \$$getbankBalance",
    );
  }

  // 2% interest calculation method
  @override
  double calculateInterest() {
    return getbankBalance * 0.02;
  }
}

class CheckingAccount extends BankAccount {
  static const double _overdraftFee = 35;

  // Constructor
  CheckingAccount(
    int accountNumber,
    String accountHolderName,
    double bankBalance,
  ) : super(accountNumber, accountHolderName, bankBalance);

  @override
  void withdraw(double amount) {
    setbankBalance = getbankBalance - amount;

    // Checking for overdraft
    if (getbankBalance < 0) {
      print(
        "Your bank has fallen below zero. An overdraft fee of \$$_overdraftFee has been applied.",
      );
      setbankBalance = getbankBalance - _overdraftFee;
    }
    print(
      "Withdrawal of \$$amount completed. Current balance: \$$getbankBalance",
    );
  }

  @override
  void deposit(double amount) {
    setbankBalance = getbankBalance + amount;
    print(
      "Amount Deposited Successfully. Your new balance is: \$$getbankBalance",
    );
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double _minimumBalance = 10000;

  // Constructor
  PremiumAccount(
    int accountNumber,
    String accountHolderName,
    double bankBalance,
  ) : super(accountNumber, accountHolderName, bankBalance);

  @override
  void withdraw(double amount) {
    if (getbankBalance - amount < _minimumBalance) {
      print(
        "Withdrawal denied. A minimum balance of \$$_minimumBalance must be maintained.",
      );
      return;
    }
    setbankBalance = getbankBalance - amount;
  }

  @override
  void deposit(double amount) {
    setbankBalance = getbankBalance + amount;
    print(
      "Amount Deposited Successfully. Your new balance is: \$$getbankBalance",
    );
  }

  @override
  double calculateInterest() {
    return getbankBalance * 0.05;
  }
}

// For interest-bearing accounts
abstract class InterestBearing {
  double calculateInterest();
}

class Bank {
  List<BankAccount> _accounts = [];

  // Create a new account
  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created successfully: ${account.getAccountNumber}");
  }

  // Find an account by account number
  // Method
  BankAccount? findAccount(int accountNumber) {
    for (BankAccount account in _accounts) {
      if (account.getAccountNumber == accountNumber) {
        print("Account found for account number: $accountNumber");
        return account;
      }
    }
    print("Account not found for account number: $accountNumber");
    return null;
  }

  // Transfer money between accounts
  void transferMoney(
    int fromAccountNumber,
    int toAccountNumber,
    double amount,
  ) {
    BankAccount? fromAccount = findAccount(fromAccountNumber);
    BankAccount? toAccount = findAccount(toAccountNumber);

    if (fromAccount == null || toAccount == null) {
      print("Transfer error: missing or invalid account");
      return;
    }

    if (amount <= 0) {
      print("The transfer amount is not valid.");
      return;
    }

    double initialBalance = fromAccount.getbankBalance;
    fromAccount.withdraw(amount); //Calls the account's specific withdraw method

    double afterWithdrawal = fromAccount.getbankBalance;
    if (afterWithdrawal == initialBalance) {
      print(
        "Transfer failed: withdrawal from account ${fromAccount.getAccountNumber} unsuccessful.",
      );
    } else {
      toAccount.deposit(amount);
      print(
        "$amount succcessfully transfered from ${fromAccount.getAccountNumber} to ${toAccount.getAccountNumber}.",
      );
    }
  }

  // Generate reports of all accounts
  void generateReport() {
    if (_accounts.isEmpty) {
      print("Account not found.");
      return;
    }

    for (BankAccount account in _accounts) {
      account.displayAccountInfo();
      print("");
    }
  }
}

void main() {
  Bank bank = Bank();

  BankAccount savingAccount = SavingsAccount(100, "Ram", 15000);
  BankAccount checkingAccount = CheckingAccount(200, "Sita", 28000);
  BankAccount premiumAccount = PremiumAccount(300, "Hari", 32000);

  print("Created accounts are: ");
  bank.createAccount(savingAccount);
  bank.createAccount(checkingAccount);
  bank.createAccount(premiumAccount);

  print("\nFinding Accounts: ");
  bank.findAccount(100);
  bank.findAccount(150);

  print("\nTransfer Amount: ");
  bank.transferMoney(100, 200, 12000);
  print("");
  bank.transferMoney(100, 200, 3100); // 100 is saving account
  print("");
  bank.transferMoney(200, 100, 44000); // 200 is checking account

  print("\nPerforming Transactions:");
  savingAccount.withdraw(200);
  checkingAccount.withdraw(250);
  premiumAccount.deposit(5000);

  print("\nBank Accounts Reports:");
  bank.generateReport();
}
