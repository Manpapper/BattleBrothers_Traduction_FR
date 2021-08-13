this.roster_of_12_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.roster_of_12";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous allons augmenter l\'effectif de la compagnie à une douzaine d\'hommes ! Cela fera de nous une force formidable et nous permettra d\'entreprendre des travaux plus rentables.";
		this.m.UIText = "Avoir un groupe d\'au moins 12 hommes";
		this.m.TooltipText = "Engagez suffisamment d\'hommes pour avoir un groupe complet d\'au moins 12 hommes. Visitez les colonies à travers le pays pour trouver des recrues qui répondent à vos besoins. Avoir une équipe complète vous permettra d\'accepter des contrats plus dangereux et mieux payés.";
		this.m.SuccessText = "[img]gfx/ui/events/event_80.png[/img]Ayant finalement rassemblé l\'argent et l\'équipement, vous parvenez à réunir un effectif complet de douze combattants compétents. Lorsque vous descendez la rue principale de la ville actuelle, les hommes entament une marche enthousiaste. Quelques habitants marmonnent à voix basse que de sales mercenaires s\'emparent de la ville, mais d\'autres marchent à côté et crient les paroles avec vous. %SPEECH_ON%Tenez-vous bien droits, mes frères. Les gens peuvent voir qu\'il s\'agit d\'une vraie compagnie de mercenaires maintenant, et pas d\'une poignée de vagabonds errants.%SPEECH_OFF%%highestexperience_brother% déclare.%SPEECH_ON%Nous faisons du commerce en force, et maintenant que notre nombre a augmenté, notre prix aussi.%SPEECH_OFF%Il semble qu\'il ait raison. Vous remarquez un noble particulièrement gros qui jauge la compagnie comme s\'il avait déjà une tâche en tête. %companyname% est maintenant une force sur laquelle on peut compter. Une fois que les hommes se seront installés pour boire un verre, vous devriez peut-être faire un autre tour en ville pour voir si d\'autres contrats plus lucratifs sont disponibles.";
		this.m.SuccessButtonText = "Nous y arrivons.";
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() == "scenario.militia")
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1 && this.World.Assets.getOrigin().getID() != "scenario.deserters" && this.World.Assets.getOrigin().getID() != "scenario.raiders")
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= 12)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.getPlayerRoster().getSize() >= 12)
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

