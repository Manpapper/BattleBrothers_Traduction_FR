this.have_z_crowns_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_z_Couronnes";
		this.m.Duration = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les couronnes sont synonymes de pouvoir et d\'influence, et on n\'en a jamais assez.\nRassemblons 50 000 couronnes et gagnons notre place parmi les nobles et les rois !";
		this.m.UIText = "Avoir au moins 50 000 couronnes.";
		this.m.TooltipText = "Ayez au moins 50 000 couronnes pour être compté parmi les riches. Vous pouvez gagner de l\'argent en remplissant des contrats, en pillant des camps et des ruines, ou en faisant du commerce.";
		this.m.SuccessText = "[img]gfx/ui/events/event_04.png[/img]Du pillage, du pillage et, oui, encore du pillage ! La compagnie a accumulé des richesses qui rivalisent avec le trésor d\'un dragon. Les meilleures armures et armes sont à votre disposition. Si vous souhaitez louer un navire, ou une flotte de navires, il vous suffit de claquer des doigts. Des vendeurs de toutes sortes proposent leurs meilleures marchandises lorsque vous êtes en ville, et sont prêts à vous aider à trouver de nouvelles façons de dépenser votre or. Lorsque votre richesse rivalise avec celle d\'un noble, vous n\'avez plus besoin de vous en remettre à lui. Vous pouvez acquérir votre propre titre de noblesse et vos propres terres, ou embrasser la carrière de banquier, si jamais vous en avez assez de jouer les nourrices pour cette bande de rustres au caractère bien trempé.";
		this.m.SuccessButtonText = "Excellent.";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 25)
		{
			return;
		}

		if (this.World.Assets.getMoney() >= 45000)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getMoney() < 10000 && !this.World.Ambitions.getAmbition("ambition.have_y_Couronnes").isDone())
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getMoney() >= 50000)
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

