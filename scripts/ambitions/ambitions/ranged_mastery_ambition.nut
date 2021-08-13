this.ranged_mastery_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.ranged_mastery";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "La compagnie manque d\'archers compétents, ce qui limite nos options tactiques.\nNous allons former trois hommes à la maîtrise de l\'arc ou de l\'arbalète et être mortels à distance !";
		this.m.UIText = "Avoir des hommes avec le perk de Maîtrise de l\'Arc ou de l\'Arbalète.";
		this.m.TooltipText = "Avoir des hommes avec le perk de Maîtrise de l\'Arc ou de l\'Arbalète.";
		this.m.SuccessText = "[img]gfx/ui/events/event_10.png[/img]À chaque occasion, vous encouragez les hommes sous votre commandement à lâcher quelques volées. Tout le monde participe, même les rustres à l\'esprit lent qui dormiraient dans leur armure si vous les laissiez faire. N\'importe quelle cible suffit : le tronc d\'un petit arbre, une biche qui broute au petit matin ou un éclaireur gobelin qui fuit pour sauver sa vie.%SPEECH_ON%Oui, nous sommes la terreur des bottes de foin dans tout le pays!%SPEECH_OFF%%randombrother% dit, en faisant référence à un choix de cible commun pendant l\'entraînement. Il s\'esquive lorsqu\'une flèche d\'un de ses camarades siffle près de son crâne et commence à maudire le tireur.\n\nAvec beaucoup d\'entraînement, ces flèches frappent de plus en plus près du centre de la cible, et maintenant que la compagnie dispose d\'archers mieux entraînés, votre ligne de front respire mieux et vit, au moins légèrement, plus longtemps.";
		this.m.SuccessButtonText = "Cela nous servira.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(3, this.getBrosWithMastery()) + "/3)";
	}

	function getBrosWithMastery()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local count = 0;

		foreach( bro in brothers )
		{
			local p = bro.getCurrentProperties();

			if (p.IsSpecializedInBows)
			{
				count = ++count;
			}
			else if (p.IsSpecializedInCrossbows)
			{
				count = ++count;
			}
		}

		return count;
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		local count = this.getBrosWithMastery();

		if (count >= 3)
		{
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		local count = this.getBrosWithMastery();

		if (count >= 3)
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

