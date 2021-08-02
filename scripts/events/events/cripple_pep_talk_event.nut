this.cripple_pep_talk_event <- this.inherit("scripts/events/event", {
	m = {
		Cripple = null,
		Veteran = null
	},
	function create()
	{
		this.m.ID = "event.cripple_pep_talk";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_06.png[/img]%cripple% l\'infirme demande comment fait %veteran%. Le vétéran hausse un sourcil.%SPEECH_ON%Fait quoi?%SPEECH_OFF%L\'infirme tourne autour du pot.%SPEECH_ON%Tu le sais, ça. Se battre. Chaque fois que je vais sur le terrain, je me dis que je ne suis pas à la hauteur, comme si je vous entraînais vers le bas.%SPEECH_OFF%%veteran% rigole.%SPEECH_ON%Oui, je comprends ce que tu veux dire. Un estropié n\'est pas fait pour être mercenaire. Mais est-ce ce que tu es ? Juste un estropié ? Ou es-tu un homme ? Tu peux choisir de laisser tes tremblements et ta disgrâce définir qui tu es, ou tu peux faire ton propre chemin, aussi tordu et handicapé qu\'il puisse être.%SPEECH_OFF%En hochant la tête, le visage de %cripple% se met à briller.%SPEECH_ON%Tu as raison. Je ne suis pas tout ce que je pourrais être et j\'ai le corps d\'une nonne mourante, mais aucun homme ne fera plus d\'efforts que moi !%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien dit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cripple.getImagePath());
				this.Characters.push(_event.m.Veteran.getImagePath());
				local resolve = this.Math.rand(1, 3);
				local fatigue = this.Math.rand(1, 3);
				local initiative = this.Math.rand(1, 3);
				_event.m.Cripple.getBaseProperties().Bravery += resolve;
				_event.m.Cripple.getBaseProperties().Stamina += fatigue;
				_event.m.Cripple.getBaseProperties().Initiative += initiative;
				_event.m.Cripple.getSkills().update();
				this.List = [
					{
						id = 16,
						icon = "ui/icons/bravery.png",
						text = _event.m.Cripple.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve + "[/color] de Détermination"
					},
					{
						id = 17,
						icon = "ui/icons/fatigue.png",
						text = _event.m.Cripple.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + fatigue + "[/color]de Fatigue Maximum"
					},
					{
						id = 17,
						icon = "ui/icons/initiative.png",
						text = _event.m.Cripple.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + initiative + "[/color] d\'Initiative"
					}
				];
				_event.m.Cripple.improveMood(2.0, "A été motivé par " + _event.m.Veteran.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cripple.getMoodState()],
					text = _event.m.Cripple.getName() + this.Const.MoodStateEvent[_event.m.Cripple.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local cripple_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 3 && bro.getBackground().getID() == "background.cripple")
			{
				cripple_candidates.push(bro);
			}
		}

		if (cripple_candidates.len() == 0)
		{
			return;
		}

		local veteran_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 5)
			{
				veteran_candidates.push(bro);
			}
		}

		if (veteran_candidates.len() == 0)
		{
			return;
		}

		this.m.Cripple = cripple_candidates[this.Math.rand(0, cripple_candidates.len() - 1)];
		this.m.Veteran = veteran_candidates[this.Math.rand(0, veteran_candidates.len() - 1)];
		this.m.Score = cripple_candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cripple",
			this.m.Cripple.getNameOnly()
		]);
		_vars.push([
			"veteran",
			this.m.Veteran.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cripple = null;
		this.m.Veteran = null;
	}

});

