//  Project 1: Binary Number Calculator
//  Seth Whitaker
//  06/02/2020

#include <iostream>
#include <string>
#include <cassert>
#include <math.h>

using namespace std;

int binary_to_decimal(string s);
// precondition: s is a string that consists of only 0s and 1s
// postcondition: the positive decimal integer that is represented by s

string decimal_to_binary(int n);
// precondition: n is a positive integer
// postcondition: n’s binary representation is returned as a string of 0s and 1s

string add_binaries(string b1, string b2);
// precondition: b1 and b2 are strings that consists of 0s and 1s, i.e.
//               b1 and b2 are binary representations of two positive integers
// postcondition: the sum of b1 and b2 is returned. For instance,
//  if b1 = “11”, b2 = “01”, then the return value is “100”

void menu();
// display the menu. Student shall not modify this function

int grade();
// returns an integer that represents the student’s grade of this projects.
// Student shall NOT modify

bool is_binary(string b);
// returns true if the given string s consists of only 0s and 1s; false otherwise

bool test_binary_to_decimal();
// returns true if the student’s implementation of binary_to_decimal function
// is correct; false otherwise. Student shall not modify this function

bool test_decimal_to_binary();
//  returns true if the student’s implementation of decimal_to_binary function is correct; false otherwise. Student shall not modify this function

bool test_add_binaries();
// which returns true if the student’s implementation of add_binaries function
// is correct; false otherwise. Student shall not modify this function


int main()
{
    int choice;
    string b1, b2;
    int x, score;

    
    do {
        // display menu
        menu();
        cout << "Enter you choice: ";
        cin >> choice;
        // based on choice to perform tasks
        switch (choice) {
        case 1:
            cout << "Enter a binary string: ";
            cin >> b1;
            if (!is_binary(b1))
                cout << "It is not a binary number\n";
            else
                cout << "Its decimal value is: " << binary_to_decimal(b1) << endl;
            break;

        case 2:
            cout << "Enter a positive integer: ";
            cin >> x;
            if (x <= 0)
                cout << "It is not a positive integer" << endl;
            else
                cout << "Its binary representation is: " << decimal_to_binary(x) << endl;
            break;

        case 3:
            cout << "Enter two binary numbers, separated by white space: ";
            cin >> b1 >> b2;
            if (!is_binary(b1) || !is_binary(b2))
                cout << "At least one number is not a binary" << endl;
            else
                cout << "The sum is: " << add_binaries(b1, b2) << endl;
            break;

        case 4:
            score = grade();
            cout << "If you turn in your project on blackboard now, you will get " << score << " out of 10" << endl;
            cout << "Your instructor will decide if one-two more points will be added or not based on your program style, such as good commnets (1 points) and good efficiency (1 point)" << endl;
            break;

        case 5:
            cout << "Thanks for using binary calculator program. Good-bye" << endl;
            break;
        default:
            cout << "Wrong choice. Please choose 1-5 from menu" << endl;
            break;
        }

    } while (choice != 5);
    return 0;
}

int binary_to_decimal(string s) {

    int decimal = 0; // Decimal representation of binary string

    for (int i = 0; i < s.size(); i++) { // Iterate through the string

        // Check if the current bit is a 1
        // Using size - i - 1 to start from the right of the string
        if (s[s.size() - i - 1] == '1') {   

            decimal += pow(2, i); // If it is a 1, add 2^i to the decimal version
        }
    }
    return decimal; // Return the result
}

string decimal_to_binary(int n) {

    // Special case n = 0, return "0"
    if (n == 0)
        return "0";

    string binary = "";

    // Figure out the minimum length of binary string
    // Formula in text is ceil(log2(n)), but ceil() in C++ does not work how the text
    // used it, so if log2 n is a round number, 1 must be added
    double log2n = log2(n); // find the log2 n
    if (floor(log2n) == log2n) { // if it does not have a fractional component then add 1
        log2n += 1;
    }
    int numBits = ceil(log2n);  // round up
    
    // Add each bit to binary string starting from most significant
    for (int i = 0; i < numBits; i++) {

        // check if n >= 2^x where x is the significance of the current bit
        if (n >= pow(2, numBits - i - 1)) {
            // if true, make current bit a 1 and subtract 2^x from n
            binary.push_back('1');
            n -= pow(2, numBits - i - 1);
        } else {
            // otherwise, make current bit a 0
            binary.push_back('0');
        }
    }

    return binary; // return the result
}

string add_binaries(string b1, string b2) {

    string sum = "";
    
    // Find which binary string is longer and assign corresponding string to longer and shorter
    string longer;  
    string shorter;
    if (b1.size() < b2.size()) {
        shorter = b1;
        longer = b2;
    } else {
        shorter = b2;
        longer = b1;
    }

    // Iterate over the longer binary string, and add the shorter string to it
    bool carry = false; // This is used to add 1 to the next iteration

    for (int i = 0; i < longer.size(); i++) {
        // Convert chars to ints
        int bit1 = longer[longer.size() - i - 1]-48;     // current bit from longer string
        int bit2;                                        // current bit from shorter string
        
        if (shorter.size() > i)                          // if the end of the shorter string has been reached, 
            bit2 = shorter[shorter.size() - i - 1] - 48; // treat the rest of the digits as 0
        else
            bit2 = 0;

        int bit3 = bit1 + bit2; // add the bits

        if (carry) bit3++;      // check if there was a carry from previous iteration

        // Convert decimal to binary
        // if bit3 > 1, a 1 needs to be carried
        // NOTE: the string is being created backwards. It will be reversed later
        switch (bit3) {
        case 0:
            carry = false;
            sum.push_back('0');
            break;
        case 1:
            carry = false;
            sum.push_back('1');
            break;
        case 2: 
            carry = true;
            sum.push_back('0');
            break;
        case 3:
            carry = true;
            sum.push_back('1');
            break;
        default:
            break;
        }

    }

    // There might be a carry from the last iteration of the loop. If so, add a 1 to the end
    if (carry) sum.push_back('1');

    // Reverse sum
    for (int i = 0; i < sum.size() / 2; i++) {

        char temp = sum[i];
        sum[i] = sum[sum.size() - i - 1];
        sum[sum.size() - i - 1] = temp;

    }

    return sum;
}

void menu()
{
    cout << "******************************\n";
    cout << "*          Menu              *\n";
    cout << "* 1. Binary to Decimal       *\n";
    cout << "* 2. Decinal to Binary       *\n";
    cout << "* 3. Add two Binaries        *\n";
    cout << "* 4. Grade                   *\n";
    cout << "* 5. Quit                    *\n";
    cout << "******************************\n";
}

int grade() {
    int result = 0;
    // binary_to_decimal function worth 3 points
    if (test_binary_to_decimal()) {
        cout << "binary_to_decimal function pass the test" << endl;
        result += 3;
    } else
        cout << "binary_to_decimal function failed" << endl;

    // decinal_to_binary function worth 2 points
    if (test_decimal_to_binary()) {
        cout << "decimal_to_binary function pass the test" << endl;
        result += 2;
    } else
        cout << "decimal_to_binary function failed" << endl;
    // add_binaries function worth 3 points
    if (test_add_binaries()) {
        cout << "add_binaries function pass the test" << endl;
        result += 3;
    } else
        cout << "add_binaries function pass failed" << endl;
    return result;
}

bool is_binary(string s) {
    for (int i = 0; i < s.length(); i++)
        if (s[i] != '0' && s[i] != '1') // one element in s is not '0' or '1'
            return false;  // then it is not a binary nunber representation
    return true;
}

bool test_binary_to_decimal() {
    if (binary_to_decimal("0") != 0 || binary_to_decimal("1") != 1)
        return false;
    if (binary_to_decimal("010") != 2 || binary_to_decimal("10") != 2)
        return false;
    if (binary_to_decimal("01101") != 13 || binary_to_decimal("1101") != 13)
        return false;
    return true;
}

bool test_decimal_to_binary() {
    if (decimal_to_binary(0) != "0" || decimal_to_binary(1) != "1")
        return false;
    if (decimal_to_binary(2) != "10" || decimal_to_binary(13) != "1101")
        return false;
    return true;
}

bool test_add_binaries() {
    if (add_binaries("0", "0") != "0") return false;
    if (add_binaries("0", "110101") != "110101") return false;
    if (add_binaries("1", "110111") != "111000") return false;
    if (add_binaries("101", "111011") != "1000000") return false;
    return true;
}