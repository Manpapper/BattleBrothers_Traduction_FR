this.hire_follower_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.hire_follower";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Il y a des cuisiniers, des éclaireurs et bien d\'autres qui peuvent nous aider en dehors du champ de bataille. Nous engagerons celui qui convient le mieux à nos besoins !";
		this.m.UIText = "Engagez quelqu\'un pour votre escorte de non-combattants.";
		this.m.TooltipText = "Obtenez une renommée d\'au moins \"reconnu\'\' (250) pour débloquer le premier emplacement pour un compagnon non combattant dans votre troupe de mercenaires. Vous pouvez augmenter votre renommée en remplissant des contrats et en gagnant des batailles. Ensuite, engagez un compagnon non-combattant dans l\'écran d\'escorte. Certains compagnon non-combattant nécessitent que vous remplissiez des conditions préalables spécifiques pour débloquer leurs services.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]%SPEECH_ON%Alors, ils ne sont pas combattants ?%SPEECH_OFF%Un des mercenaires demande. Vous secouez la tête, et ils se grattent la leur.%SPEECH_ON%Mais ils sont engagés quand même ?%SPEECH_OFF% Vous acquiescez. Le mercenaire pince les lèvres pendant une seconde puis précise : %SPEECH_ON% Et absolument aucun combat ? %SPEECH_OFF% Aucun combat. %SPEECH_ON%Aucun ? Donc ils vont juste se contenter de faire la première tâche qui passe ici ou là ? %SPEECH_OFF% Vous expliquez que tous les rôles importants dans un groupe de mercenaires et ils ne doivent pas nécessairement être des rôles de combat. Après que vous ayez exposé toutes les tâches que les autres pourraient accomplir ici, le mercenaire réfléchit un moment : %SPEECH_ON% Peuvent-ils s\'occuper du comptage des stocks, alors ? Parce que j\'en ai vraiment marre de ça.%SPEECH_OFF%Non. Bien sûr que non. Vous ne laisserez jamais votre punition secrète aller à quelqu\'un d\'autre.";
		this.m.SuccessButtonText = "Cela nous aidera beaucoup dans les jours à venir.";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Ambitions.getDone() < 1)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < this.Const.BusinessReputation[this.Const.FollowerSlotRequirements[0]] - 100)
		{
			return;
		}

		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Retinue.getNumberOfCurrentFollowers() >= 1)
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

