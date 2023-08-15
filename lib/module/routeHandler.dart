import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:rasitu_login/Login/failure.dart';
import 'package:rasitu_login/Login/login.dart';
import 'package:rasitu_login/Login/splashscreen.dart';
import 'package:rasitu_login/Mainscreen/sales/estimate.dart';
import 'package:rasitu_login/Mainscreen/sidenavigator.dart';
import 'package:rasitu_login/module/pagebuilder.dart';

class RouteHandler {
  final GoRouter router =
      GoRouter(errorBuilder: (context, state) => const Failure(), routes: [
    GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      name: "failed",
      path: "/failed",
      builder: (context, state) => const Failure(),
    ),
    // GoRoute(path: "/items/new",builder: (context, state) => SideNavigator(
    //           page: state.pathParameters["page"]!,
    //         )),
    GoRoute(
        name: "home",
        path: "/home/:page",
        pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: SideNavigator(
              page: state.pathParameters["page"]!,
            )),
        routes: [
          GoRoute(
              path: ':id',
              pageBuilder: (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: SideNavigator(
                        page: state.pathParameters["page"]!,
                        id: state.pathParameters["id"]!),
                  ))
        ]),
    GoRoute(
        name: "invoice",
        path: "/invoice",
        builder: (context, state) {
          return Failure();
        },
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => PageBuilder(
              invoiceId: "",
              name: "Invoice",
            ),
          ),
          GoRoute(
            path: ':invoiceId/edit',
            builder: (context, state) => PageBuilder(
              invoiceId: state.pathParameters['invoiceId']!,
              name: "Invoice",
            ),
          )
        ]),
    GoRoute(
        name: "estimate",
        path: "/estimate",
        builder: (context, state) {
          return Failure();
        },
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => PageBuilder(
              invoiceId: "",
              name: "Estimate",
            ),
          ),
          GoRoute(
            path: ':estimateId/edit',
            builder: (context, state) => PageBuilder(
              invoiceId: state.pathParameters['estimateId']!,
              name: "Estimate",
            ),
          )
        ]),
    GoRoute(
        name: "deliverychallan",
        path: "/deliverychallan",
        builder: (context, state) {
          return Failure();
        },
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => PageBuilder(
              invoiceId: "",
              name: "Delivery Challan",
            ),
          ),
          GoRoute(
            path: ':challanId/edit',
            builder: (context, state) => PageBuilder(
              invoiceId: state.pathParameters['challanId']!,
              name: "Delivery Challan",
            ),
          )
        ]),
    GoRoute(
        name: "salesorder",
        path: "/salesorder",
        builder: (context, state) {
          return Failure();
        },
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => PageBuilder(
              invoiceId: "",
              name: "Sales Order",
            ),
          ),
          GoRoute(
            path: ':orderId/edit',
            builder: (context, state) => PageBuilder(
              invoiceId: state.pathParameters['challanId']!,
              name: "Sales Order",
            ),
          )
        ]),
    GoRoute(
        name: "creditnotes",
        path: "/creditnotes",
        builder: (context, state) {
          return Failure();
        },
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => PageBuilder(
              invoiceId: "",
              name: "Credit Notes",
            ),
          ),
          GoRoute(
            path: ':challanId/edit',
            builder: (context, state) => PageBuilder(
              invoiceId: state.pathParameters['challanId']!,
              name: "Credit Notes",
            ),
          )
        ]),
    GoRoute(
        name: "purchaseorder",
        path: "/purchaseorder",
        builder: (context, state) {
          return Failure();
        },
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => PageBuilder(
              invoiceId: "",
              name: "Purchase Order",
            ),
          ),
          GoRoute(
            path: ':orderid/edit',
            builder: (context, state) => PageBuilder(
              invoiceId: state.pathParameters['orderid']!,
              name: "Purchase Order",
            ),
          )
        ])
  ]);
}
