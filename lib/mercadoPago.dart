paymentFailMercadoPagoUri(uriParams) {
  var uri =  new Uri(scheme: 'instore', host: 'payment', queryParameters: {
    'paymentId': uriParams['vtexPaymentId'],
    //'cardBrandName': '',
    //'firstDigits': '',
    //'lastDigits': '',
    'acquirerName': 'Mercado Pago',
    //'tid': '',
    //'acquirerAuthorizationCode': uriParams['payment_id'],
    //'nsu': '',
    //'merchantReceipt': '',
    //'customerReceipt': '',
    'responsecode': '110',
    'reason': uriParams['error_detail'],
    'success': 'false',
    'acquirer': uriParams['acquirer'],
  });

  return uri;
}

paymentMercadoPagoUri(uriParams) {
  var uri =  Uri.https('www.mercadopago.com', '/point/integrations', {
    'amount': parseAmount(uriParams['amount']),
    'description': uriParams['paymentSystemName'].toString().trim().replaceAll(' ', ''),
    ////'disable_back_button': 'true',
    //'card_type': getCardType(uriParams['paymentType']),
    ////'installments': uriParams['installments'],
    //'client_id': null,
    //'client_secret': null,
    //'application_fee': null,
    //'sponsor_id': null,
    //'notification_url': null,
    //'payer_email': uriParams['payerEmail'],
    //'collector_id': '',
    ////'is_kiosk': 'true',
    //'identification': uriParams['payerIdentification'],
    //'external_reference': '',
    'success_url': 'vtexlink://payment_result?acquirer=mercado_pago&vtexPaymentId=' + uriParams['paymentId'],
    'fail_url': 'vtexlink://payment_fail?acquirer=mercado_pago&vtexPaymentId=' + uriParams['paymentId'],
//          'result_status': '',
//          'payment_id': '',
//          'trunc_card_holder': '',
//          'error': '',
//          'error_detail': '',
//          'STATUS': ''
  });

  return uri;
}

paymentResultMercadoPagoUri(uriParams) {
  var uri =  Uri(scheme: 'instore', host: 'payment', queryParameters: {
    'paymentId': uriParams['vtexPaymentId'],
    //'cardBrandName': '',
    //'firstDigits': '',
    //'lastDigits': '',
    'acquirerName': 'Mercado Pago',
    //'tid': '',
    'acquirerAuthorizationCode': uriParams['payment_id'],
    //'nsu': '',
    //'merchantReceipt': '',
    //'customerReceipt': '',
    'responsecode': '0',
    //'reason': '',
    'success': 'true',
    'acquirer': uriParams['acquirer'],
  });

  return uri;

}

parseAmount(amount) {
  return amount.substring(0, amount.length - 2) + '.' + amount.substring(amount.length - 2);
}

getCardType(paymentType) {
  if (paymentType == 'credit') return 'CREDIT_CARD';
  if (paymentType == 'debit') return 'DEBIT_CARD';
  return null;
}
