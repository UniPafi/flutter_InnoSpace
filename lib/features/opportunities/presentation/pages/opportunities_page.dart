import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_innospace/core/enums/status.dart';
import 'package:flutter_innospace/features/opportunities/presentation/pages/create_opportunity_page.dart';
import 'package:flutter_innospace/features/opportunities/presentation/pages/opportunity_detail_page.dart';
import 'package:flutter_innospace/features/opportunities/presentation/widgets/opportunity_card.dart';
import '../blocs/opportunity_list/opportunity_list_bloc.dart';

class OpportunitiesPage extends StatefulWidget {
  const OpportunitiesPage({super.key});

  @override
  State<OpportunitiesPage> createState() => _OpportunitiesPageState();
}

class _OpportunitiesPageState extends State<OpportunitiesPage> {
  @override
  void initState() {
    super.initState();
    context.read<OpportunityListBloc>().add(FetchOpportunities());
  }

  Future<void> _navigateToCreatePage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateOpportunityPage()),
    );
    
    if (result == true && mounted) {
      context.read<OpportunityListBloc>().add(FetchOpportunities());
    }
  }

  Future<void> _navigateToDetailPage(int opportunityId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OpportunityDetailPage(opportunityId: opportunityId),
      ),
    );
    
    if (mounted) {
       context.read<OpportunityListBloc>().add(FetchOpportunities());
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color headerColor = Color(0xFF7E57C2);
    const Color backgroundColor = Color(0xFFEDE7F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Mis Convocatorias', // Or "Mis Proyectos" as in image
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: headerColor,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: BlocBuilder<OpportunityListBloc, OpportunityListState>(
        builder: (context, state) {
          switch (state.status) {
            case Status.loading:
            case Status.initial:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            case Status.success:
              if (state.opportunities.isEmpty) {
                return const Center(child: Text('No tienes convocatorias creadas.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: state.opportunities.length,
                itemBuilder: (context, index) {
                  final opportunity = state.opportunities[index];
                  return OpportunityCard(
                    opportunity: opportunity,
                    onTap: () => _navigateToDetailPage(opportunity.id),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePage,
        backgroundColor: const Color(0xFFFFCDD2), // Pinkish accent from one of your images, or Blue
        foregroundColor: Colors.black87, // Or white if blue
        child: const Icon(Icons.add),
      ),
    );
  }
}