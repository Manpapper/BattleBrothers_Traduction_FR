this.wound_heals_event <- this.inherit("scripts/events/event", {
	m = {
		Injured = null
	},
	function create()
	{
		this.m.ID = "event.wound_heals";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "{C\'est bon de vous revoir. | Comme neuf.}",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local bg = _event.m.Injured.getBackground().getID();

				if (bg == "background.monk" || bg == "background.flagellant" || bg == "background.pacified_flagellant" || bg == "background.monk_turned_flagellant" || bg == "background.cultist")
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]{Vous allez vérifier l\'état de %hurtbrother% - Il a été victime d\'une terrible blessure, il n\'y a pas longtemps et le fait de savoir que d\'autres se préoccupent de lui peut parfois lui remonter le moral. Vous pensiez le trouver en train de soigner ses blessures, mais vous êtes surpris de voir qu\'il est en bonne santé. Ses blessures se sont apparemment cicatrisées si rapidement que certains parleraient de miracle. | %hurtbrother% a été blessé au combat et vous estimez qu\'il serait préférable d\'aller voir comment il va. Étonnamment, il se porte plutôt bien. Ses blessures ont cicatrisé si rapidement qu\'on pourrait croire qu\'il a fait appel à la magie noire pendant que personne ne le regardait. Il n\'y a aucun signe de magie noire, seulement un homme robuste et difficile à tuer, en chair et en os. | %hurtbrother% pénètre dans votre tente et expose sa blessure, ou ce qu\'il en reste. Il semble que cette blessure plutôt voyante soit complètement guérie. Le mercenaire vous regarde avec un sourire étonné.%SPEECH_ON%Ils devront faire plus d\'efforts pour me faire disparaître de ce monde, capitaine.%SPEECH_OFF% | %hurtbrother% entre dans votre tente et vous montre une ancienne blessure. Il parle avec beaucoup d\'enthousiasme.%SPEECH_ON%C\'est un miracle ou quoi?%SPEECH_OFF%La blessure est pratiquement guérie. Vous dites à cet homme que son corps est constitué de choses plus résistantes et que les dieux n\'y sont pour rien dans cette histoire. Il secoue la tête.%SPEECH_ON%Vous devriez avoir plus confiance en vous.%SPEECH_OFF% | Vous cherchez %hurtbrother% - le mercenaire qui avait subi une sacrée blessure la dernière fois que vous l\'avez vu. Cependant, il est de bonne humeur. Il se retourne vers vous, prenant une petite pause dans son travail d\'aiguisage de l\'acier.%SPEECH_ON%Besoin de quelque chose, sir?%SPEECH_OFF%Vous vous renseignez sur sa blessure. Il hausse les épaules.%SPEECH_ON%Je ne meurs pas facilement. {J\'ai mangé beaucoup de ces choses orange pointues quand j\'étais jeune. | J\'ai mangé beaucoup de laitues en grandissant. Quelques-uns dirait que je suis difficile à... tuer.}%SPEECH_OFF%}";	
				}
				else
				{
					this.Text = "[img]gfx/ui/events/event_34.png[/img]{Vous allez vérifier l\'état de %hurtbrother% - Il a été victime d\'une terrible blessure, il n\'y a pas longtemps et le fait de savoir que d\'autres se préoccupent de lui peut parfois lui remonter le moral. Vous pensiez le trouver en train de soigner ses blessures, mais vous êtes surpris de voir qu\'il est en bonne santé. Ses blessures se sont apparemment cicatrisées si rapidement que certains parleraient de miracle. | %hurtbrother% a été blessé au combat et vous estimez qu\'il serait préférable d\'aller voir comment il va. Étonnamment, il se porte plutôt bien. Ses blessures ont cicatrisé si rapidement qu\'on pourrait croire qu\'il a fait appel à la magie noire pendant que personne ne le regardait. Il n\'y a aucun signe de magie noire, seulement un homme robuste et difficile à tuer, en chair et en os. | %hurtbrother% pénètre dans votre tente et expose sa blessure, ou ce qu\'il en reste. Il semble que cette blessure plutôt voyante soit complètement guérie. Le mercenaire vous regarde avec un sourire étonné.%SPEECH_ON%Ils devront faire plus d\'efforts pour me faire disparaître de ce monde, capitaine.%SPEECH_OFF% | %hurtbrother% entre dans votre tente et vous montre une ancienne blessure. Il parle avec beaucoup d\'enthousiasme.%SPEECH_ON%C\'est un miracle ou quoi?%SPEECH_OFF%La blessure est pratiquement guérie. Vous dites à cet homme que son corps est constitué de choses plus résistantes et que les dieux n\'y sont pour rien dans cette histoire. Il secoue la tête.%SPEECH_ON%Oui, je sais. Mais ce serait bien s\'ils prenaient soin de moi aussi. Juste au cas où...%SPEECH_OFF% | Vous cherchez %hurtbrother% - le mercenaire qui avait subi une sacrée blessure la dernière fois que vous l\'avez vu. Cependant, il est de bonne humeur. Il se retourne vers vous, prenant une petite pause dans son travail d\'aiguisage de l\'acier.%SPEECH_ON%Besoin de quelque chose, sir?%SPEECH_OFF%Vous vous renseignez sur sa blessure. Il hausse les épaules.%SPEECH_ON%Je ne meurs pas facilement. {J\'ai mangé beaucoup de ces choses orange pointues quand j\'étais jeune. | J\'ai mangé beaucoup de laitues en grandissant. Quelques-uns dirait que je suis difficile à... tuer.}%SPEECH_OFF%}";
				}

				this.Characters.push(_event.m.Injured.getImagePath());
				local injuries = _event.m.Injured.getSkills().query(this.Const.SkillType.TemporaryInjury);
				local injury = injuries[this.Math.rand(0, injuries.len() - 1)];
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Injured.getName() + " ne souffre plus de " + injury.getNameOnly()
					}
				];
				injury.removeSelf();
				_event.m.Injured.updateInjuryVisuals();
				_event.m.Injured.getSkills().update();
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() != "background.slave" && bro.getSkills().hasSkillOfType(this.Const.SkillType.TemporaryInjury))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Injured = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hurtbrother",
			this.m.Injured.getName()
		]);
	}

	function onClear()
	{
		this.m.Injured = null;
	}

});

