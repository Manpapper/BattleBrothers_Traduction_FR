this.anatomist_white_nachzehrer_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_white_nachzehrer";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{%anatomist% n\'a pas beaucoup écrit dans son journal ces derniers temps. Quand il le fait, le stylo semble seulement effleurer les pages de temps en temps, sans rien griffonner d\'important. Vous lui demandez ce qui le tracasse tant. D\'un ton sombre, il dit que son principal espoir en venant sur ces terres était de trouver le Nachzehrer blanc, un monstre plus grand que tous ceux de son espèce. Vous lui dites que vous avez tué quelques nachs qui étaient assez grassouillets, mais l\'anatomiste secoue la tête.%SPEECH_ON%D\'après la littérature, ce nachzehrer ne peut être abattu par aucun homme car il a atteint de telles proportions que sa chair est devenue blanche et qu\'il est couvert de grandes crêtes de peau calleuse qu\'aucun acier ne peut pénétrer. Il a été repéré errant dans ces terres et j\'espérais le trouver, mais il semble que, peut-être, j\'ai été induit en erreur. Peut-être que les anatomistes qui m\'ont raconté cette histoire m\'ont mis sur une grande chasse à la bécasse. J\'ai peur, vaurien, qu\'on se soit moqué de moi.%SPEECH_OFF%Vous lui dites que cette créature ressemble au \"roi\" des nachzehrers, et si c\'est le cas, peut-être qu\'elle ne se déplace plus, mais qu\'elle utilise une petite armée de nachzehrers de moindre importance pour exécuter ses ordres. L\'anatomiste sourit.%SPEECH_ON%C\'est peut-être le cas! Bien sûr, il a fallu l\'œil inquisiteur des laïcs, si habitués à regarder nos suzerains pourpres, pour attirer mon attention sur ce point!%SPEECH_OFF%En accord avec vous-même, vous dites que le \"Nachzehrer blanc\" est peut-être pâle car il ne voit pas beaucoup le soleil. L\'anatomiste rit.%SPEECH_ON%S\'il vous plaît, vaurien, la première observation était une contribution suffisante de votre part.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ne laissez pas votre \"Nacho blanc\" vous faire un œil au beurre noir, tête de nœud.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.improveMood(1.5, "Had his faith in the existence of the white nachzehrer renewed");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
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
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

