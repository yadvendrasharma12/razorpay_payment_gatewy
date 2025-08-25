import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazarpayScreen extends StatefulWidget {
  const RazarpayScreen({super.key});

  @override
  State<RazarpayScreen> createState() => _RazarpayScreenState();
}

class _RazarpayScreenState extends State<RazarpayScreen> {
  final Razorpay _razorpay = Razorpay();
final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Razorpay options
  var options = {
    'key': 'rzp_test_R8igK97LA8o9PA', // Replace with your Razorpay key
    'amount': 1000000, // Amount in paise (1000 = ₹10)
    'name': 'Acme Corp.',
    'description': 'Fine T-Shirt',
    // 'order_id': 'order_EMBFqjDHEEn80l', // Use only if you generate order ID from backend
    'prefill': {
      'contact': '7895306931',
      'email': 'sharmayadvendra8@gmail.com',
    }
  };

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Successful: ${response.paymentId}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.code} | ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Selected: ${response.walletName}")),
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Razorpay Payment Gateway",
          style: GoogleFonts.poppins(
            fontStyle: FontStyle.normal,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            textStyle: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left_square_fill,
            size: 30,
          ),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Amount",
                    ),
                  ),
                ),
                SizedBox(
                  height:30,
                ),
                GestureDetector(
                  onTap: () {
                    try {
                      _razorpay.open(options); // <-- OPEN CHECKOUT HERE
                    } catch (e) {
                      debugPrint("Error: $e");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 52,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Payment",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
