this.anatomist_dissects_beetles_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_dissects_beetles";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Vous trouvez %anatomist% accroupi sur un morceau de bois. Il a disposé, devant lui, un trio de coléoptères. L\'un d\'eux est épinglé au bois par une aiguille et ses petites pattes pédalent dans les airs. Le deuxième n\'est rien d\'autre qu\'une enveloppe corporelle, ses pattes ayant été retirées et placées à côté. Le dernier est dans une petite boite remplie d\'eau, lesté d\'une pierre. L\'%anatomiste% secoue la tête.%SPEECH_ON%La pression que ces créatures peuvent subir est assez impressionnante. Les dommages physiques ne sont pas fatales comme c\'est le cas chez nous. Prenez ces trois-là, par exemple: percés, démembrés et noyés. Et pourtant, ils vivent encore. L\'efficacité est autre chose, n\'êtes-vous pas d\'accord?%SPEECH_OFF%Bien sûr. Vous lui demandez où il a trouvé tous ces scarabées. Il hausse les épaules.%SPEECH_ON%Ils rampent partout sur nous quand on dort. Il se trouve que je reste éveillé pour les prendre sur le fait. Celui qui est immergé, par exemple, je l\'ai surpris en train de picorer ton lobe d\'oreille.%SPEECH_OFF%Vous lui dites de continuer ses recherches et de capturer autant de coléoptères que possible.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je devrais commencer à dormir avec un casque.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.improveMood(1.0, "Fascinated with beetles");

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

