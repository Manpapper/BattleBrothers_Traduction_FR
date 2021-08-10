this.contracts_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		ContractsToComplete = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.contracts";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Nous devons nous établir comme des mercenaires sur lesquels on peut compter.\nSoyons testés encore et encore pour le prouver sans aucun doute !";
		this.m.UIText = "Accomplir plus de contrats";
		this.m.TooltipText = "Accomplissez 8 contrats supplémentaires de toute nature pour prouver votre fiabilité sans aucun doute.";
		this.m.SuccessText = "[img]gfx/ui/events/event_62.png[/img]Lorsque vous débutez, le monde vous voit pour ce que vous êtes : l\'ambition armée d\'une arme. Tout le monde a un rêve, et environ la moitié de ces hommes ont une arme. Vous n\'étiez pas unique, pas exceptionnel, ni même particulièrement dangereux si vous regardez votre ancien vous dans les yeux. Mais vous l\'avez fait. Les portes se sont fermées devant vous. Les tentatives de marchandage qui vous ont fait perdre de bonnes affaires. Les crachats. Tellement de crachats. C\'est un monde froid et vous avez osé vous réchauffer tout seul. Et vous avez réussi.\n\n Contrats à votre actif, contrats à l\'horizon, ils se confondent. Une culture de la victoire a commencé à envahir %companyname% et vous avez de bonnes raisons d\'être fier de votre maîtrise de cette culture.";
		this.m.SuccessButtonText = "Nous sommes en train de nous faire un nom.";
	}

	function getUIText()
	{
		local d = 8 - (this.m.ContractsToComplete - this.World.Contracts.getContractsFinished());
		return this.m.UIText + " (" + this.Math.min(8, d) + "/8)";
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

		if (this.World.Contracts.getContractsFinished() >= 15)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.ContractsToComplete = this.World.Contracts.getContractsFinished() + 8;
		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Contracts.getContractsFinished() >= this.m.ContractsToComplete)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU16(this.m.ContractsToComplete);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.ContractsToComplete = _in.readU16();
	}

});

