this.make_nobles_aware_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.make_nobles_aware";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous devons attirer l\'attention d\'une des maisons nobles pour un travail plus rentable. Ils jouent à des jeux dangereux, mais qu\'importe, tant que la paie est bonne.";
		this.m.RewardTooltip = "Vous débloquerez de tout nouveaux contrats émis par des nobles qui rapporte plus.";
		this.m.UIText = "Atteindre le rang de renom \"Professionnel\".";
		this.m.TooltipText = "Devenez connu en étant \"Professionnel\" (1 050 renommées) afin d\'attirer l\'attention des maisons nobles. Vous pouvez augmenter votre renommée en remplissant des contrats et en gagnant des batailles.";
		this.m.SuccessText = "[img]gfx/ui/events/event_31.png[/img]Pensant faire parler de vous avec le nom de %companyname%, et ainsi augmenter vos chances auprès de la noblesse, vous avez poussé vos hommes à faire de grandes choses, en faisant preuve d\'une bravoure exceptionnelle et en faisant couler beaucoup de sang. Après plusieurs contrats et plus d\'une escarmouche, vous avez travaillé assez dur et assez longtemps pour que certains seigneurs remarquent les compétences de la compagnie.\n\nIl s\'agit des gentilshommes qui règnent sur le pays grâce à un ancêtre mort depuis longtemps qui a soumis un groupe de paysans désarmés. Comme le dit %highestexperience_brother%, maintenant ces consanguins sont assez impressionnés par vous pour mêler la compagnie à une de leurs querelles. Si vous vous lavez le visage et demandez poliment, ils devraient vous favoriser avec un contrat profitable de temps en temps. Vous pouvez vous féliciter !";
		this.m.SuccessButtonText = "Nous sommes sur le point d\'atteindre les poches profondes de la noblesse !";
	}

	function onUpdateScore()
	{
		if (this.World.Ambitions.getDone() < 2)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 800)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.battle_standard").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 1050 && this.World.FactionManager.isGreaterEvil())
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 1050)
		{
			return true;
		}

		return false;
	}

	function onReward()
	{
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/special.png",
			text = "Les nobles vous donneront désormais des contrats"
		});

		if (!this.World.Assets.getOrigin().isFixedLook())
		{
			if (this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
			{
				this.World.Assets.updateLook(14);
			}
			else
			{
				this.World.Assets.updateLook(2);
			}

			this.m.SuccessList.push({
				id = 10,
				icon = "ui/icons/special.png",
				text = "Votre apparence sur la carte du monde a été mise à jour."
			});
		}
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

