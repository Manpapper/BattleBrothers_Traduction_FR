this.defeat_undead_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_undead";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les morts-vivants se répandent sur toutes les terres, tuant et dévorant à vue. Nous devons mettre fin à cela, ou bientôt le monde tel que nous le connaissons n\'existera plus !";
		this.m.UIText = "Vaincre le fléau des morts-vivants";
		this.m.TooltipText = "Vainquez le fléau des morts-vivants ! Chaque contrat contre eux, et chaque armée ou emplacement détruit, vous rapprochera de la sauvegarde du monde des hommes.";
		this.m.SuccessText = "[img]gfx/ui/events/event_73.png[/img]Des cadavres ambulants qui déambulent en haillons. Les cimetières de chaque hameau ont commencé à les vomir, mais ce n\'était que le début. D\'anciennes légions d\'une époque révolue se sont réveillées. Jamais fatiguées, jamais craintives, elles marchaient comme une machine froide, toujours en avant. Ils ont conquis le monde connu une fois, et ils pourraient bien l\'avoir fait à nouveau, si ce n\'était pour une bande de mercenaires très soudée.%SPEECH_ON%Des hommes morts marchant, des os marchant dans des armures étrangères, des choses qui ne sont pas de ce monde... Je ne pensais pas voir de telles horreurs un jour. Mais nous avons vaincu!%SPEECH_OFF%%bravest_brother% s\'exclame, tenant son arme haute comme pour donner le signal d\'une charge.%SPEECH_ON%%companyname% a prévalu même contre cet ennemi ! Qui se dresserait contre nous maintenant?%SPEECH_OFF% Qui, en effet ?";
		this.m.SuccessButtonText = "Le monde des hommes est sauvé. Pour l\'instant.";
	}

	function getUIText()
	{
		local f = this.World.FactionManager.getGreaterEvil().Strength / this.Const.Factions.GreaterEvilStartStrength;
		local text;

		if (f >= 0.95)
		{
			text = "Perdant";
		}
		else if (f >= 0.5)
		{
			text = "Incertain";
		}
		else if (f >= 0.25)
		{
			text = "Victoire Légère";
		}
		else
		{
			text = "Victoire";
		}

		return this.m.UIText + " (" + text + ")";
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isUndeadScourge())
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		this.m.Score = 10;
	}

	function onCheckSuccess()
	{
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 3)
		{
			return true;
		}

		this.World.Ambitions.updateUI();
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

