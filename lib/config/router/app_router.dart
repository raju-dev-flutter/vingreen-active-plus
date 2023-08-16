import 'package:flutter/material.dart';

import '../../presentation/pages/attendance/attendance_history_page.dart';
import '../../presentation/pages/invoice/invoice_add_page.dart';
import '../../presentation/pages/invoice/invoice_edit_page.dart';
import '../../presentation/pages/invoice/invoice_page.dart';
import '../../presentation/pages/lead/create_timeline_page.dart';
import '../../presentation/pages/lead/lead_detail_page.dart';
import '../../presentation/pages/lead/lead_filter_page.dart';
import '../../presentation/pages/lead/lead_page.dart';
import '../../presentation/pages/lead/lead_update_page.dart';
import '../../presentation/pages/petty_cash/petty_cash_add_page.dart';
import '../../presentation/pages/petty_cash/petty_cash_detail_page.dart';
import '../../presentation/pages/petty_cash/petty_cash_page.dart';
import '../../presentation/pages/profile/idcard_page.dart';
import '../../presentation/pages/profile/profile_update_page.dart';
import '../../presentation/pages/proforma_invoice/proforma_invoice_add_page.dart';
import '../../presentation/pages/proforma_invoice/proforma_invoice_edit_page.dart';
import '../../presentation/pages/proforma_invoice/proforma_invoice_page.dart';
import '../../presentation/pages/quotation/quotation_add_page.dart';
import '../../presentation/pages/quotation/quotation_edit_page.dart';
import '../../presentation/pages/quotation/quotation_page.dart';
import '../../presentation/pages/startup/permission_page.dart';
import '../../presentation/pages/startup/splash_page.dart';
import '../../presentation/pages/task/task_add_page.dart';
import '../../presentation/pages/task/task_detail_page.dart';
import '../../presentation/pages/task/task_filter_page.dart';
import '../../presentation/pages/task/task_update_page.dart';
import '../../presentation/pages/ticket/ticket_add_page.dart';
import '../../presentation/pages/ticket/ticket_detail_page.dart';
import '../../presentation/pages/ticket/ticket_filter_page.dart';
import '../../presentation/pages/ticket/ticket_page.dart';
import '../../presentation/pages/ticket/ticket_update_page.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      /* ========= Splash Page============= */
      case SplashPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashPage());
      /* ========= Permission Page ============= */
      case PermissionPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PermissionPage());

      /* ========= IdCard Page ============= */
      case IdCardPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const IdCardPage());
      /* ========= ProfileUpdate Page ============= */
      case ProfileUpdatePage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileUpdatePage());

      /* ========= Lead Page ============= */
      case LeadPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LeadPage());

      /* ========= Lead Edit Page ============= */
      case LeadUpdatePage.id:
        final args = settings.arguments as LeadUpdatePage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                LeadUpdatePage(leadId: args.leadId));
      /* ========= Lead Details Page ============= */
      case LeadDetailsPage.id:
        final args = settings.arguments as LeadDetailsPage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                LeadDetailsPage(leadId: args.leadId));
      /* ========= Lead Timeline Page ============= */
      case CreateTimeLinePage.id:
        final args = settings.arguments as CreateTimeLinePage;
        return MaterialPageRoute(
            builder: (BuildContext context) => CreateTimeLinePage(
                  leadId: args.leadId,
                  mobileNo: args.mobileNo,
                  communicationMedium: args.communicationMedium,
                ));
      /* ========= Lead Filter Page ============= */
      case LeadFilterPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LeadFilterPage());

      /* ========= Attendance History Page ============= */
      case AttendanceHistoryPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AttendanceHistoryPage());

      /* ========= Task Detail Page ============= */
      case TaskDetailPage.id:
        final args = settings.arguments as TaskDetailPage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                TaskDetailPage(taskId: args.taskId));
      /* ========= Task add Page ============= */
      case TaskAddPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TaskAddPage());
      /* ========= Task Update Page ============= */
      case TaskUpdatePage.id:
        final args = settings.arguments as TaskUpdatePage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                TaskUpdatePage(taskId: args.taskId));
      /* ========= Task Filter Page ============= */
      case TaskFilterPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TaskFilterPage());

      /* ========= Ticket Page ============= */
      case TicketPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TicketPage());

      /* ========= Ticket Detail Page ============= */
      case TicketDetailPage.id:
        final args = settings.arguments as TicketDetailPage;
        return MaterialPageRoute(
            builder: (BuildContext context) => TicketDetailPage(
                ticketId: args.ticketId, statusName: args.statusName));

      /* ========= Ticket add Page ============= */
      case TicketAddPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TicketAddPage());

      /* ========= Ticket Update Page ============= */
      case TicketUpdatePage.id:
        final args = settings.arguments as TicketUpdatePage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                TicketUpdatePage(ticketId: args.ticketId));

      /* ========= Ticket Filter Page ============= */
      case TicketFilterPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const TicketFilterPage());

      /* ========= Petty Cash Page ============= */
      case PettyCashPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PettyCashPage());

      /* ========= Petty Cash detail Page ============= */
      case PettyCashDetailPage.id:
        final args = settings.arguments as PettyCashDetailPage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                PettyCashDetailPage(expense: args.expense));

      /* ========= Petty Cash Add Page ============= */
      case PettyCashAddPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const PettyCashAddPage());

      /* ========= Quotation Page ============= */
      case QuotationPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const QuotationPage());

      /* ========= Quotation Add Page ============= */
      case QuotationAddPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const QuotationAddPage());

      /* ========= Quotation Edit Page ============= */
      case QuotationEditPage.id:
        final args = settings.arguments as QuotationEditPage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                QuotationEditPage(quotationId: args.quotationId));

      /* ========= Invoice Page ============= */
      case InvoicePage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const InvoicePage());

      /* ========= Invoice Page ============= */
      case InvoiceAddPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const InvoiceAddPage());

      /* ========= Invoice Page ============= */
      case InvoiceEditPage.id:
        final args = settings.arguments as InvoiceEditPage;
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                InvoiceEditPage(invoiceId: args.invoiceId));

      /* ========= Proforma Invoice Page ============= */
      case ProformaInvoicePage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProformaInvoicePage());

      /* ========= Proforma Invoice Page ============= */
      case ProformaInvoiceAddPage.id:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProformaInvoiceAddPage());

      /* ========= Invoice Page ============= */
      case ProformaInvoiceEditPage.id:
        final args = settings.arguments as ProformaInvoiceEditPage;
        return MaterialPageRoute(
            builder: (BuildContext context) => ProformaInvoiceEditPage(
                proformaInvoiceId: args.proformaInvoiceId));

      /* ========= No Route view ============= */
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(body: Center(child: Text('No route defined')));
        });
    }
  }
}
