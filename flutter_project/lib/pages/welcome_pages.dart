part of 'pages.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80), 
              Image.asset(
                'assets/images/logo.png', 
                height: 150, 
                fit: BoxFit.contain, 
              ),
              SizedBox(height: 40), 
              Text(
                "Manage Your Money with BANK CELENGAN",
                style: secondaryTextStyle.copyWith(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), 
              Text(
                "Platform that makes it easy for you to manage your money",
                style: blackTextStyle.copyWith(
                  fontSize: 16, 
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Container(
                    height: 60, 
                    width: 60, 
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, 
                      color: secondaryColor, 
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward, 
                        size: 35, 
                        color: Colors.white, 
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

