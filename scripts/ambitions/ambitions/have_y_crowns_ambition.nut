this.have_y_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_Couronnes";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Si une ou deux batailles tournent mal, nous risquons de nous retrouver \nà court d\'argent et d\'équipement. La compagnie va donc constituer une réserve de 10.000 Couronnes.";
		this.m.UIText = "Avoir au moins 10 000 Couronnes";
		this.m.TooltipText = "Ayez au moins 10 000 couronnes en réserve, afin de survivre si les choses tourne mal à l\'avenir. Vous pouvez gagner de l\'argent en remplissant des contrats, en pillant des camps et des ruines, ou en faisant du commerce.";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]Votre réserve de pièces et autres objets de valeur étant plus pleine cela vous permet de dormir plus facilement. Les hommes aussi, sachant qu\'ils n\'auront pas à vous pourchasser à travers la steppe lorsque vous devrez payer vos salaires. Vous ne serez plus désavantagé lors de la négociation de contrats, et vous ne manquerez pas d\'hommes ou d\'équipement si une bataille ou deux tournent mal. \n\nVotre nouvelle réserve commence également à ouvrir des portes pour %compagnie%. Les marchands, les prêteurs d\'argent et les nobles ont une chose en commun : ils préfèrent se frotter à leurs semblables. Obtenir une audience peut être une corvée s\'ils vous soupçonnent d\'avoir les poches vides. Mais maintenant que vous avez prouvé que vous êtes un homme de ressources, la compagnie est devenue plus attrayante pour les individus fortunés et les décideurs.";
		this.m.SuccessButtonText = "Excellent!";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() > 9000)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 3)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.trader" && !this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 10000)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

