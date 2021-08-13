this.defeat_greenskins_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_greenskins";
		this.m.Duration = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "L\'invasion des Peaux Vertes menace de balayer notre monde. Nous devons rester forts et la repousser, car c\'est ainsi que naissent les légendes !";
		this.m.UIText = "Vaincre l\'invasion des peaux vertes";
		this.m.TooltipText = "Détruisez l\'invasion des Peaux Vertes ! Chaque contrat contre eux, et chaque armée ou emplacement détruit, vous rapprochera de la sauvegarde du monde des hommes.";
		this.m.SuccessText = "[img]gfx/ui/events/event_81.png[/img]C\'était une tâche qui n\'avait jamais été entreprise par les hommes de la compagnie auparavant, pour repousser une invasion entière menée par des ennemis les plus féroces que l\'homme ait jamais rencontré. Un ennemi qui ne pouvait être raisonné, dont l\'esprit étranger ne connaît ni pitié ni compassion, mais seulement la guerre. Orques et gobelins s\'étaient unis dans une marée verte sauvage qui menaçait de balayer la race humaine. Sous un soleil impitoyable le jour et à la lumière des villes en feu la nuit, la compagnie a fait campagne contre la menace verte à travers les régions frontalières, la déracinant partout où elle levait sa tête hideuse et balafrée. Les hommes ont mené de dures batailles et fait de nombreux sacrifices, mais cela en valait la peine.\n\n %companyname% l\'a emporté. Après bien des combats sauvages, après d\'innombrables jours où la vie de chaque homme semblait dépendre d\'un lancer de dé, la marée verte semblait enfin s\'apaiser. Alors que les orcs et les gobelins se dispersent dans la nature, vous savez que le monde des hommes est sauvé. Pour l\'instant.";
		this.m.SuccessButtonText = "Les bardes vont chanter nos noms maintenant. S\'il en reste.";
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
		if (!this.World.FactionManager.isGreenskinInvasion())
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
		if (this.World.FactionManager.getGreaterEvil().Type == 0 && this.World.FactionManager.getGreaterEvil().LastType == 2)
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

