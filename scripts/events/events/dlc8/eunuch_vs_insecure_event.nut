this.eunuch_vs_insecure_event <- this.inherit("scripts/events/event", {
	m = {
		Eunuch = null,
		Insecure = null
	},
	function create()
	{
		this.m.ID = "event.eunuch_vs_insecure";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%eunuch% l\'eunuque et %insecure% le fragile sont assis et discutent. L\'eunuque secoue sa tête.%SPEECH_ON%Vos inquiétudes n\'a aucun sens pour moi, %insecure%. Regarde-moi. Quand le vent souffle contre mon pantalon, je ne sens que du tissu contre l\'intérieur de ma cuisse. Vous avez une idée de l\'étrangeté de cette sensation? Mais vous me voyez me plaindre? Non. Quand la moitié de la compagnie va au bordel du coin et se tape une nana, me voyez-vous assis dans un coin à pleurer? Bien sûr que non!%SPEECH_OFF%%insecure% acquiesce.%SPEECH_ON%Vous savez quoi, espèce de bâtard sans queue, vous avez raison. Si vous pouvez brasser de l\'air et en être heureux, alors je ne peux pas être si effrayé et faible.%SPEECH_OFF%Le mercenaire peu sûr de lui se lève et part. %eunuque% serre les lèvres.%SPEECH_ON%Brasser de l\'air? Est-ce que cet abruti vient de me dire que je suis un branleur? Hé, hé! Je vais aller brasser ta mère plutôt!%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne laisse pas son insécurité déteindre sur toi, %eunuque%.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Insecure.getImagePath());
				this.Characters.push(_event.m.Eunuch.getImagePath());
				_event.m.Insecure.getSkills().removeByID("trait.insecure");
				this.List = [
					{
						id = 10,
						icon = "ui/traits/trait_icon_03.png",
						text = _event.m.Insecure.getName() + " is no longer insecure"
					}
				];
				_event.m.Eunuch.worsenMood(1.0, "Was disrespected");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Eunuch.getMoodState()],
					text = _event.m.Eunuch.getName() + this.Const.MoodStateEvent[_event.m.Eunuch.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local eunuch_candidates = [];
		local insecure_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.eunuch" && bro.getSkills().hasSkill("trait.insecure"))
			{
				insecure_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.eunuch" && bro.getLevel() >= 4 && !bro.getSkills().hasSkill("trait.insecure"))
			{
				eunuch_candidates.push(bro);
			}
		}

		if (insecure_candidates.len() == 0 || eunuch_candidates.len() == 0)
		{
			return;
		}

		this.m.Eunuch = eunuch_candidates[this.Math.rand(0, eunuch_candidates.len() - 1)];
		this.m.Insecure = insecure_candidates[this.Math.rand(0, insecure_candidates.len() - 1)];
		this.m.Score = 5 * insecure_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"eunuch",
			this.m.Eunuch.getNameOnly()
		]);
		_vars.push([
			"insecure",
			this.m.Insecure.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Eunuch = null;
		this.m.Insecure = null;
	}

});

