this.strength_contest_event <- this.inherit("scripts/events/event", {
	m = {
		Strong1 = null,
		Strong2 = null
	},
	function create()
	{
		this.m.ID = "event.strength_contest";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img] %strong1% et %strong2% - les hommes les plus forts du groupe - se livrent apparemment à une sorte de compétition pour voir qui est le meilleur. Vous les voyez transporter d\'énormes pierres d\'un côté à l\'autre d\'un terrain de compétition. Puis ils se relaient pour voir jusqu\'où ils peuvent lancer ces mêmes pierres. Puis ils font rouler les pierres sur une colline voisine. Et enfin, ils voient qui peut enterrer complètement une pierre le plus rapidement.\n\n Dans l\'ensemble, il y a beaucoup de pierres lourdes qui sont bousculées et à la fin de cette affaire festive, les deux hommes sont complètement épuisés. Même s\'il n\'y a pas de gagnant, cette tradition ancestrale de déplacer des pierres sans but précis a amélioré le moral des hommes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous ne sommes que de simples créatures.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong1.getImagePath());
				this.Characters.push(_event.m.Strong2.getImagePath());
				_event.m.Strong1.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Strong2.getFlags().increment("ParticipatedInStrengthContests", 1);
				_event.m.Strong1.getBaseProperties().Stamina += 1;
				_event.m.Strong1.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong1.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Fatigue Maximum"
				});
				_event.m.Strong2.getBaseProperties().Stamina += 1;
				_event.m.Strong2.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong2.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Fatigue Maximum"
				});
				_event.m.Strong1.improveMood(1.0, "S\'est lié d\'amitié avec " + _event.m.Strong2.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Strong1.getMoodState()],
					text = _event.m.Strong1.getName() + this.Const.MoodStateEvent[_event.m.Strong1.getMoodState()]
				});
				_event.m.Strong2.improveMood(1.0, "S\'est lié d\'amitié avec " + _event.m.Strong1.getName());
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Strong2.getMoodState()],
					text = _event.m.Strong2.getName() + this.Const.MoodStateEvent[_event.m.Strong2.getMoodState()]
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.strong") && !bro.getSkills().hasSkill("trait.bright"))
			{
				if (!bro.getFlags().has("ParticipatedInStrengthContests") || bro.getFlags().get("ParticipatedInStrengthContests") < 2)
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() < 2)
		{
			return;
		}

		this.m.Strong1 = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Strong2 = null;
		this.m.Score = candidates.len() * 5;

		do
		{
			this.m.Strong2 = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		while (this.m.Strong2 == null || this.m.Strong2.getID() == this.m.Strong1.getID());
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"strong1",
			this.m.Strong1.getName()
		]);
		_vars.push([
			"strong2",
			this.m.Strong2.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Strong1 = null;
		this.m.Strong2 = null;
	}

});

